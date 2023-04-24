import Foundation
import Markdown

struct GPTMessage: Codable {
    let role: String
    let content: String
}

extension Array where Element == GPTMessage {
    var contentCount: Int {
        reduce(0, { $0 + $1.content.count
})}}

struct Request: Codable {
    let model: String
    let temperature: Double
    let messages: [GPTMessage]
    let stream: Bool
}

struct ErrorRootResponse: Decodable {
    let error: ErrorResponse
}

struct ErrorResponse: Decodable {
    let message: String
    let type: String?
}

struct StreamCompletionResponse: Decodable {
    let choices: [StreamChoice]
}

struct CompletionResponse: Decodable {
    let choices: [Choice]
    let usage: Usage?
}

struct Usage: Decodable {
    let promptTokens: Int?
    let completionTokens: Int?
    let totalTokens: Int?
}

struct Choice: Decodable {
    let message: GPTMessage
    let finishReason: String?
}

struct StreamChoice: Decodable {
    let finishReason: String?
    let delta: StreamMessage
}

struct StreamMessage: Decodable {
    let role: String?
    let content: String?
}

struct ParserResult: Identifiable {
    let id = UUID()
    let attributedString: AttributedString
    let isCodeBlock: Bool
    let codeBlockLanguage: String?
}

actor ResponseParsingTask {
    func parse(text: String) async -> AttributedOutput {
        let document = Document(parsing: text)
        var markdownParser = MarkdownAttributedStringParser()
        let results = markdownParser.parserResults(from: document)
        return AttributedOutput(string: text, results: results)
    }
}
