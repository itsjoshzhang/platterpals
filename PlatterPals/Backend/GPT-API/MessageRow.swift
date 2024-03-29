import SwiftUI

struct MessageRow: Identifiable {
    let id = UUID()
    var isInteractingWithChatGPT: Bool

    let sendImage: String
    let send: MessageRowType
    var sendText: String {
        send.text
    }
    let responseImage: String
    var response: MessageRowType?
    var responseText: String? {
        response?.text
    }
    var responseError: String?
    var show: Bool = true
}

enum MessageRowType {
    case attributed(AttributedOutput)
    case rawText(String)

    var text: String {
        switch self {
        case .attributed(let attributedOutput):
            return attributedOutput.string
        case .rawText(let string):
            return string
        }}}

struct AttributedOutput {
    let string: String
    let results: [ParserResult]
}

struct DotLoadingView: View {
    
    @State private var showCircle1 = false
    @State private var showCircle2 = false
    @State private var showCircle3 = false
    
    var body: some View {
        HStack {
            Circle()
                .opacity(showCircle1 ? 1 : 0)
            Circle()
                .opacity(showCircle2 ? 1 : 0)
            Circle()
                .opacity(showCircle3 ? 1 : 0)
        }
        .frame(width: 40)
        .foregroundColor(.gray.opacity(0.5))
        .onAppear { performAnimation() }
    }
    
    func performAnimation() {
        let animation = Animation.easeInOut(duration: 0.4)
        withAnimation(animation) {
            self.showCircle1 = true
            self.showCircle3 = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(animation) {
                self.showCircle2 = true
                self.showCircle1 = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(animation) {
                self.showCircle2 = false
                self.showCircle3 = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.performAnimation()
        }}}
