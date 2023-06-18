import SwiftUI

struct Match: View {

    @State var city = ""
    @State var showGPT = false
    @FocusState var focus: Bool

    @EnvironmentObject var DM: DataManager
    @StateObject var VM = ViewModel(api: ChatGPTAPI())

    var body: some View {
        let my = DM.my()
        NavigationStack {
        VStack(spacing: 16) {

        Text("Your PlatterPal can find you a match based on your bio and favorite foods!")
            .multilineTextAlignment(.center)
            .foregroundColor(.pink)
            .font(.title3).bold()

            if showGPT {
                ForEach(VM.messages) { row in
                    MessageRowView(message: row) { row in
                        Task { @MainActor in
                            await VM.retry(message: row)
            }}}
            Button("Retry") {
                withAnimation {
                    VM.clearMessages()
                    showGPT = false
                }
            }
            .buttonStyle(.bordered)
            .disabled(VM.isInteractingWithChatGPT)

            } else {
            Image("guide3")
                .resizable()
                .scaledToFit()

            HStack {
                Text("Search near:")
                    .foregroundColor(.secondary)
                City(city: $city)
                    .focused($focus)
            }
            Button("Get Started") {
                focus = false
                matchLogic()
            }
            .buttonStyle(.borderedProminent)
            .disabled(count(city) || bioShort())
        }
        if bioShort() {
            Text("Your bio is too short to find a match! Head to your Profile page.")
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
        }
        .navigationTitle("Match Me")
        .padding(16)
        .onAppear {
            city = my.city
        }
        .onTapGesture {
            focus = false
        }
        .background {
            Back()
        }}}

    func matchLogic() {
        withAnimation {
            showGPT = true
        }
        let my = DM.my()
        let list = DM.userList

        let intro = "You're an AI that matches users based on their bios. "
        var input = "My bio is: \(my.text). "

        input += "Reply with the info of ONE user that best matches me. "
        input += "End your reply with the following - Name: user's name "

        var index = 1
        input += "... Here is a list of users: "
        for i in 0 ..< list.count {

            let user = list[i]
            if check(user: user, my: my) {
                input += "\(index)) Name: \(user.name), Bio: \(user.text); "
                index += 1
            }
        }
        if index == 1 {
            input = "Reply with this exactly - There aren't any users near you yet! "
            input += "Here's someone you might like: \(list.shuffled()[0].name)"
        }
        VM.api = ChatGPTAPI(aiModel: DM.aiModel, intro: intro, text: input)

        Task { @MainActor in
            VM.inputMessage = "Find one user who best matches me."
            await VM.sendTapped(show: true)

            print(VM.api.systemMessage)
        }
    }
    func trim(_ text: String) -> String {
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }
    func check(user: User, my: User) -> Bool {
        return user.id != my.id && !user.rest && user.prof &&
        trim(user.city) == trim(my.city)
    }
    func bioShort() -> Bool {
        return DM.my().text.count < 16
    }
}
