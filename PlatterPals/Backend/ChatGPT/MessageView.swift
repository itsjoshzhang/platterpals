import SwiftUI
#if os(iOS)
import Markdown
#endif

struct MessageRowView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    let message: MessageRow
    let retryCallback: (MessageRow) -> Void
    
    var imageSize: CGSize {
        #if os(iOS) || os(macOS)
        CGSize(width: 25, height: 25)
        #elseif os(watchOS)
        CGSize(width: 20, height: 20)
        #else
        CGSize(width: 80, height: 80)
        #endif
    }
    
    var body: some View {
        VStack(spacing: 0) {
            messageRow(rowType: message.send, image: message.sendImage, bgColor: colorScheme == .light ? .white : Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 0.5))
            
            if let response = message.response {
                Divider()
                messageRow(rowType: response, image: message.responseImage, bgColor: colorScheme == .light ? .gray.opacity(0.1) : Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 1), responseError: message.responseError, showDotLoading: message.isInteractingWithChatGPT)
                Divider()
            }}}
    
    func messageRow(rowType: MessageRowType, image: String, bgColor: Color, responseError: String? = nil, showDotLoading: Bool = false) -> some View {

        #if !os(watchOS)
        HStack(alignment: .top, spacing: 24) {
            messageRowContent(rowType: rowType, image: image, responseError: responseError, showDotLoading: showDotLoading)
        }
        #if os(tvOS)
        .padding(32)
        #else
        .padding(16)
        #endif
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(bgColor)
        #endif
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
                    #if os(tvOS)
                    responseTextView(text: text)
                    #else
                    Text(text)
                        .multilineTextAlignment(.leading)
                        #if os(iOS) || os(macOS)
                        .textSelection(.enabled)
                        #endif
                    #endif
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
                #if os(tvOS)
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding()
                #else
                DotLoadingView()
                    .frame(width: 60, height: 30)
                #endif
            }}}
    
    func attributedView(results: [ParserResult]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(results) { parsed in
                if parsed.isCodeBlock {
                    #if os(iOS)
                    CodeBlockView(parserResult: parsed)
                        .padding(.bottom, 24)
                    #else
                    Text(parsed.attributedString)
                        #if os(iOS) || os(macOS)
                        .textSelection(.enabled)
                        #endif
                    #endif
                } else {
                    Text(parsed.attributedString)
                        #if os(iOS) || os(macOS)
                        .textSelection(.enabled)
                        #endif
                }}}}}

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
        #if os(iOS)
        let document = Document(parsing: rawString)
        var parser = MarkdownAttributedStringParser()
        let results = parser.parserResults(from: document)
        return MessageRowType.attributed(.init(string: rawString, results: results))
        #else
        MessageRowType.rawText(rawString)
        #endif
    }
    static var rawString = ""
}
