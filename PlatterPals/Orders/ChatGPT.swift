import Foundation
import SwiftUI

struct ChatGPT: View {
    
    @StateObject var vm = ViewModel(api: ChatGPTAPI(
        apiKey: "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"))
    @State var isShowingTokenizer = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
        ContentView(vm: vm)
        .toolbar {
        ToolbarItem {
            Button("Clear") {
                vm.clearMessages()
                dismiss()
            }
            .disabled(vm.isInteractingWithChatGPT)
        }
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Tokenizer") {
                self.isShowingTokenizer = true
            }
            .disabled(vm.isInteractingWithChatGPT)
        }}}
        .fullScreenCover(isPresented: $isShowingTokenizer) {
            NavigationTokenView()
        }}}

struct NavigationTokenView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
        TokenizerView()
        .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Close") {
                dismiss()
            }}}}
        .interactiveDismissDisabled()
    }
}

struct TextView: UIViewRepresentable {
    let output: TokenOutput

    let colors = [
        UIColor(red: 199/255, green: 195/255, blue: 212/255, alpha: 1),
        UIColor(red: 202/255, green: 236/255, blue: 202/255, alpha: 1),
        UIColor(red: 241/255, green: 218/255, blue: 181/255, alpha: 1),
        UIColor(red: 236/255, green: 180/255, blue: 180/255, alpha: 1),
        UIColor(red: 183/255, green: 219/255, blue: 241/255, alpha: 1)]

    func updateUIView(_ textView: UITextView, context: Context) {
        let attributedText = NSMutableAttributedString()
        output.stringTokens.enumerated().forEach { index, string in

            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.preferredFont(forTextStyle: .body),
                .kern: 1,
                .backgroundColor: colors[index % colors.count],]

            let attributedTokenText = NSAttributedString(string:
                                      string, attributes: attributes)
            attributedText.append(attributedTokenText)
        }
        textView.attributedText = attributedText
    }
    func makeUIView(context: Context) -> UITextView {
        let tv = UITextView()
        tv.isEditable = false
        return tv
    }
}
