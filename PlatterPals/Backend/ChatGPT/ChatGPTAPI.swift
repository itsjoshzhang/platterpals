import Foundation

class ChatGPTAPI: ObservableObject, @unchecked Sendable {

    // ## PARAMETERS ## \\
    private let apiKey: String
    private var model: String
    private var temperature: Double
    private var systemMessage: GPTMessage
    private var historyList = [GPTMessage]()

    // ## URL LOGIC ## \\
    private let urlSession = URLSession.shared

    private var urlRequest: URLRequest {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = "POST"
        headers.forEach {
            urlRequest.setValue($1, forHTTPHeaderField: $0)
        }
        return urlRequest
    }

    // ## MISC LOGIC ## \\
    
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

    // ## PARAMETERS ## \\

    init() {
        apiKey = "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"
        model = "gpt-4"
        systemMessage = .init(role: "system", content: "You are an AI named Foodie that suggests food and restaurants nearby.")
        temperature = 0.5
    }

    func editSets(model: String, text: String, temp: Double) {
        self.model = model
        let system = systemMessage.content + text
        systemMessage = .init(role: "system", content: system)
        temperature = temp
    }

    private func jsonBody(text: String, stream: Bool = true) throws -> Data {
        let request = Request(model: model, temperature: temperature,
                              messages: generateMessages(from: text), stream: stream)
        return try JSONEncoder().encode(request)
    }

    // ## HISTORY LIST ## \\
    
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

    // ## HTTP LOGIC ## \\
    
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
        // ## MSG STREAM ## \\
        
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
                }}}}

//    func sendMessage(_ text: String) async throws -> String {
//        var urlRequest = self.urlRequest
//        urlRequest.httpBody = try jsonBody(text: text, stream: false)
//
//        let (data, response) = try await urlSession.data(for: urlRequest)
//
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw "Invalid response"
//        }
//
//        guard 200...299 ~= httpResponse.statusCode else {
//            var error = "Bad Response: \(httpResponse.statusCode)"
//            if let errorResponse = try? jsonDecoder.decode(ErrorRootResponse.self, from: data).error {
//                error.append("\n\(errorResponse.message)")
//            }
//            throw error
//        }
//
//        do {
//            let completionResponse = try self.jsonDecoder.decode(CompletionResponse.self, from: data)
//            let responseText = completionResponse.choices.first?.message.content ?? ""
//            self.appendToHistoryList(userText: text, responseText: responseText)
//            return responseText
//        } catch {
//            throw error
//        }
//    }
}

extension String: CustomNSError {
    public var errorUserInfo: [String : Any] {
        [ NSLocalizedDescriptionKey: self ]
    }
}