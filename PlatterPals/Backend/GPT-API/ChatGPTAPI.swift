import SwiftUI

class ChatGPTAPI: ObservableObject, @unchecked Sendable {

    let apiKey = "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"
    let model: String
    let temperature = 0.5
    let instructions: String
    let systemMessage: GPTMessage
    var historyList = [GPTMessage]()

    private let urlSession = URLSession.shared

    private var urlRequest: URLRequest {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")
        var urlRequest = URLRequest(url: url!)

        urlRequest.httpMethod = "POST"
        headers.forEach {
            urlRequest.setValue($1, forHTTPHeaderField: $0)
        }
        return urlRequest
    }
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        return df
    }()
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    private var headers: [String: String] {
        ["Content-Type": "application/json",
        "Authorization": "Bearer \(apiKey)"]
    }

    init(aiModel: String = "gpt-3.5-turbo", intro: String = "", text:
         String = "") {
        model = aiModel
        instructions = text
        systemMessage = .init(role: "system", content: intro + text)
    }

    private func jsonBody(text: String, stream: Bool = true) throws -> Data {
        let request = Request(model: model, temperature: temperature,
                              messages: generateMessages(from: text), stream: stream)
        return try JSONEncoder().encode(request)
    }
    
    private func generateMessages(from text: String) -> [GPTMessage] {
        var messages = [systemMessage] + historyList + [GPTMessage(role: "user", content: text)]
        
        if messages.contentCount > (4000 * 4) {
            _ = historyList.removeFirst()
            messages = generateMessages(from: text)
        }
        return messages
    }
    
    private func appendToHistoryList(userText: String, responseText: String) {
        self.historyList.append(.init(role: "user", content: userText))
        self.historyList.append(.init(role: "assistant", content: responseText))
    }

    func deleteHistoryList() {
        self.historyList.removeAll()
    }
    
    func sendMessageStream(text: String) async throws -> AsyncThrowingStream<String, Error> {
        var urlRequest = self.urlRequest
        urlRequest.httpBody = try jsonBody(text: text)
        
        let (result, response) = try await urlSession.bytes(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw "Invalid response"
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            var errorText = ""
            for try await line in result.lines {
                errorText += line
            }
            
            if let data = errorText.data(using: .utf8), let errorResponse = try? jsonDecoder.decode(ErrorRootResponse.self, from: data).error {
                errorText = "\n\(errorResponse.message)"
            }
            
            throw "Bad Response: \(httpResponse.statusCode), \(errorText)"
        }

        return AsyncThrowingStream<String, Error> { continuation in
            Task(priority: .userInitiated) { [weak self] in
                guard let self else { return }
                do {
                    var responseText = ""
                    for try await line in result.lines {
                        if line.hasPrefix("data: "),
                           let data = line.dropFirst(6).data(using: .utf8),
                           let response = try? self.jsonDecoder.decode(StreamCompletionResponse.self, from: data),
                           let text = response.choices.first?.delta.content {
                                responseText += text
                                continuation.yield(text)
                        }
                    }
                    self.appendToHistoryList(userText: text, responseText: responseText)
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }}}}}

extension String: CustomNSError {
    public var errorUserInfo: [String : Any] {
        [ NSLocalizedDescriptionKey: self ]
    }
}
