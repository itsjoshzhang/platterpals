import SwiftUI

struct Guide: View {

    @State var page: Int
    @EnvironmentObject var DM: DataManager

    var body: some View {
        TabView(selection: $page) {
            let chat = Image(systemName: "message.fill")
            let fork = Image(systemName: "fork.knife")

        Guide2(page: 0, title: "Welcome to PlatterPals!",
               text: "Add an avatar and bio to tell us more about you.",
               next: "Swipe right for more. >>>")
            .tag(0)

        Guide2(page: 1, title: "Find foodies near you!",
               text: "Chat with friends or find new people on the map.",
               next: "Tap \"Find me a match!\" on the \(chat) page.")
            .tag(1)

        Guide2(page: 2, title: "Matchmaking made easy!",
               text: "Swipe left or right on a profile to follow them.",
               next: "Swipe right for more. >>>")
            .tag(2)

        Guide2(page: 3, title: "Don't know what to eat?",
               text: "Let your AI PlatterPal choose the perfect order.",
               next: "Fill out some info on the \(fork) page.")
            .tag(3)

        Guide2(page: 4, title: "Polish up your profile!",
               text: "Add a cover photo so people can connect with you.",
               next: "")
            .tag(4)
        }
        .environmentObject(DM)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}
struct Guide2: View {
    
    var page: Int
    var title: String
    var text: String
    var next: LocalizedStringKey
    @State var image: UIImage?

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
        VStack(spacing: 16) {

        Text(title)
            .foregroundColor(.pink)
            .font(.title).bold()

        if page == 0 {
            EditProf(image: DM.myAvatar)
                .environmentObject(DM)
                .frame(height: UIwidth)

        } else if page == 4 {
            Upload2(scale: 0.5, image: $image)

        } else {
            Image("guide\(page)")
                .resizable()
                .scaledToFit()
        }
        Text(text)
            .multilineTextAlignment(.center)
            .foregroundColor(.secondary)
            .padding(.horizontal, 16)
            .font(.title2)

        if page == 4 {
            Button("Get Started") {
                if let image = image {
                    DM.putImage(image: image, path: "profiles")
                }
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 16)

        } else {
            Text(next)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .foregroundColor(.pink)
                .font(.title3).bold()
            }
        }
        .toolbar {
            ToolbarItem {
                Button("\(Image(systemName: "chevron.down")) ") {
                    dismiss()
                }}}
        .background {
            Back()
        }}}}

struct Terms: View {
    var body: some View {
        NavigationStack {
        VStack(alignment: .leading, spacing: 16) {

        Text("PlatterPals displays user-generated content. This includes yourself and other users. We take specific steps to moderate content and prevent abusive behavior.")

        Text("There is no tolerance for offensive content or abusive users. This includes profiles and chats that display inappropiate images or are unsuitable for viewing.")

        Text("Users may filter such content and hide specific profiles, report accounts by flagging any profile / post, and block abusive users in the profile / chat pages.")

        Text("PlatterPals will act on such content within 24 hours by removing it and banning the flagged user. For support or inquiries, please visit www.platterpals.com.")
        Spacer()
        }
        .padding(16)
        .navigationTitle("Terms and EULA")
        .foregroundColor(.secondary)
        .background {
            Back()
        }}}}
