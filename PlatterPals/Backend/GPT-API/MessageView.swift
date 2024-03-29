import SwiftUI
import Markdown

struct MessageRowView: View {
    
    let message: MessageRow
    let retryCallback: (MessageRow) -> Void
    
    var imageSize: CGSize {
        CGSize(width: 25, height: 25)
    }
    
    var body: some View {
        if message.show {
            VStack(spacing: 0) {
                messageRow(rowType: message.send, image: message.sendImage, bgColor: .white.opacity(0.1))

                if let response = message.response {
                    Divider()
                    messageRow(rowType: response, image: message.responseImage, bgColor: .gray.opacity(0.1), responseError: message.responseError, showDotLoading: message.isInteractingWithChatGPT)
                    Divider()
                }}}}
    
    func messageRow(rowType: MessageRowType, image: String, bgColor: Color, responseError: String? = nil, showDotLoading: Bool = false) -> some View {
        HStack(alignment: .top, spacing: 24) {
            messageRowContent(rowType: rowType, image: image, responseError: responseError, showDotLoading: showDotLoading)
        }
        .padding(16)
        .frame(maxWidth: UIwidth, alignment: .leading)
        .background(bgColor)
    }
    
    @ViewBuilder
    func messageRowContent(rowType: MessageRowType, image: String, responseError: String? = nil, showDotLoading: Bool = false) -> some View {
        if image.hasPrefix("http"), let url = URL(string: image) {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .frame(width: imageSize.width, height: imageSize.height)
            } placeholder: {
                ProgressView()
            }
        } else {
            Image(image)
                .resizable()
                .frame(width: imageSize.width, height: imageSize.height)
        }
        VStack(alignment: .leading) {
            switch rowType {
            case .attributed(let attributedOutput):
                attributedView(results: attributedOutput.results)
                
            case .rawText(let text):
                if !text.isEmpty {
                    Text(text)
                        .multilineTextAlignment(.leading)
                        .textSelection(.enabled)
                }
            }
            if let error = responseError {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.leading)
                
                Button("Regenerate response") {
                    retryCallback(message)
                }
                .foregroundColor(.accentColor)
                .padding(.top)
            }
            if showDotLoading {
                DotLoadingView()
            }}}
    
    func attributedView(results: [ParserResult]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(results) { parsed in
                Text(parsed.attributedString)
                    .textSelection(.enabled)
                }}}}

struct MessageRowView_Previews: PreviewProvider {
    
    static let message = MessageRow(
        isInteractingWithChatGPT: true, sendImage: "logo",
        send: .rawText("What is SwiftUI?"),
        responseImage: "openai",
        response: responseMessageRowType)
    
    static let message2 = MessageRow(
        isInteractingWithChatGPT: false, sendImage: "logo",
        send: .rawText("What is SwiftUI?"),
        responseImage: "openai",
        response: .rawText(""),
        responseError: "ChatGPT is currently not available")
        
    static var previews: some View {
        NavigationStack {
            ScrollView {
                MessageRowView(message: message, retryCallback: { messageRow in
                })
                MessageRowView(message: message2, retryCallback: { messageRow in
            })}
            .previewLayout(.sizeThatFits)
        }
    }
    static var responseMessageRowType: MessageRowType {
        let document = Document(parsing: rawString)
        var parser = MarkdownAttributedStringParser()
        let results = parser.parserResults(from: document)
        return MessageRowType.attributed(.init(string: rawString, results: results))
    }
    static var rawString = ""
}
