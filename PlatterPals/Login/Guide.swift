import SwiftUI

struct Guide: View {

    @State var tag: Int
    @EnvironmentObject var DM: DataManager

    var body: some View {
        TabView(selection: $tag) {

        Guide2(page: 0, title: "Welcome to PlatterPals!",
            text: "Add an avatar and bio to tell us more about you.")
            .tag(0)

        Guide2(page: 1, title: "Find foodies near you!",
            text: "Chat with friends or find new people on the map.")
            .tag(1)

        Guide2(page: 2, title: "Matchmaking made easy!",
            text: "Swipe left or right on a profile to follow them.")
            .tag(2)

        Guide2(page: 3, title: "Don't know what to eat?",
            text: "Let your AI PlatterPal choose the perfect order.")
            .tag(3)

        Guide2(page: 4, title: "Polish up your profile!",
            text: "Add a cover photo so fellow foodies can see you.")
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
    @State var image: UIImage?

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        var my = DM.my()
        VStack(spacing: 16) {

        Text(title)
            .foregroundColor(.pink)
            .font(.title).bold()

        if page == 0 {
            EditProf()
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
                    dismiss()
                }}
            .buttonStyle(.borderedProminent)
        }}
        .background {
            Back()
        }
        .onAppear {
            my.prof = page
            DM.editUser(user: my)
        }
        .onDisappear {
            my.prof = 4
            DM.editUser(user: my)
        }}}

struct Terms: View {
    var body: some View {
        NavigationStack {
        VStack(spacing: 16) {

        Text("PlatterPals displays user-generated content. This includes other users and yourself. We take specific steps to moderate content and prevent abusive behavior.")

        Text("There is no tolerance for objectionable content or abusive users. This includes profiles and chats that have offensive content or are unsuitable for viewing.")

        Text("Users may filter such content and hide specific profiles, flag users on any of their pages / posts, and block abusive accounts in the profile and chat pages.")

        Text("PlatterPals will act on such content within 24 hours by removing it and banning the flagged user. For support or inquiries, please visit www.platterpals.com.")
        Spacer()
        }
        .padding(16)
        .navigationTitle("Terms and EULA")
        .foregroundColor(.secondary)
        .background {
            Back()
        }}}}

struct Cities: View {

    var addAll: Bool
    @Binding var city: String
    @State var page = 0

    var body: some View {
        VStack {
            let all = addAll ? ["All"]: []

        if page == 0 {
            Picker("", selection: $city) {
                ForEach(all + cityList, id: \.self) {
                    Text($0)

        }}} else if page == 1 {
            Picker("", selection: $city) {
                ForEach(all + allCities, id: \.self) {
                    Text($0)

        }}} else {
            TextField("Enter a location", text: $city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .submitLabel(.done)

            Max(count: 32, text: $city)
        }
        }
        .frame(maxWidth: UIwidth, alignment: .leading)
        .onChange(of: city) {_ in

            if city == "More..." {
                page += 1
                if page == 1 {
                    city = addAll ? "All": "Berkeley"
                } else {
                    city = ""
                }}}}}
