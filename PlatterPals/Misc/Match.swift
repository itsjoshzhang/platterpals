import SwiftUI

struct Match: View {

    @State var city = ""
    @State var showGPT = false
    @FocusState var focus: Bool

    @EnvironmentObject var DM: DataManager
    @StateObject var VM = ViewModel(api: ChatGPTAPI())

    var body: some View {
        NavigationStack {
        VStack {
        Text("Your PlatterPal can find you a match based on your bios and favorite foods.")
            .foregroundColor(.secondary)
            .font(.title2)

        Image("guide3")
            .resizable()
            .scaledToFit()

        HStack {
            Text("Search near: ")
                .foregroundColor(.secondary)
            City(city: $city)
                .focused($focus)
        }
        Button("Get Started") {
            focus = false
            matchLogic()
        }
        .buttonStyle(.borderedProminent)

        .disabled(city.trimmingCharacters(in:
            .whitespacesAndNewlines).isEmpty)
        }
        .navigationTitle("Match Me")
        .padding(16)
        .onAppear {
            city = DM.my().city
        }
        .onTapGesture {
            focus = false
        }
        .background {
            Back()
        }}}

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

