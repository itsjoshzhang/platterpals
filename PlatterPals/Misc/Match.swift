import SwiftUI

struct Match: View {
    @State var showGPT = false

    @EnvironmentObject var DM: DataManager
    @StateObject var VM = ViewModel(api: ChatGPTAPI())

    var body: some View {
        Button("Let's Go!") {
            matchLogic()
        }
        .buttonStyle(.bordered)
    }
    func matchLogic() {
        let intro = "You're an AI that matches users based on their bios and favorite foods. "
        var text = "secondary text"

        VM.api = ChatGPTAPI(aiModel: DM.aiModel, intro: intro, text: text)
        withAnimation {
            showGPT = true
        }
        print(VM.api.systemMessage)
    }
}

