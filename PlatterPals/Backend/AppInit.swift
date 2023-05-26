import SwiftUI
import Firebase

// ## APP VERSION ## \\
private let VERSION = 0
// MARK: - CHANGE THIS


@main
// ## START APP ## \\
struct AppInit: App {
    init() {
        FirebaseApp.configure()
        UIView.appearance().tintColor = .systemPink
    }
    var body: some Scene {
        WindowGroup {
            Splash()
        }}}

// ## PAGE TABS ## \\
struct MyTabView: View {

    @State var tag = 3
    @StateObject var MD = MapsData()
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        Group {
        if DM.version == VERSION {

        // ## NO UPDATE ## \\

        TabView(selection: $tag) {
        Orders()
            .tabItem {
                Image(systemName: "menucard")
            }.tag(1)
        Chats()
            .environmentObject(MD)
            .tabItem {
                Image(systemName: "message")
            }.tag(2)
        Home()
            .tabItem {
                Image(systemName: "house")
            }.tag(3)
        Suggest()
            .environmentObject(MD)
            .tabItem {
                Image(systemName: "fork.knife")
            }.tag(4)
        MyProfile()
            .tabItem {
                Image(systemName: "person")
            }.tag(5)
        }
        .environmentObject(DM)
        .onAppear {
            if let c = MD.LM?.location?.coordinate {
                DM.sendPin(pin: Location(id: DM.my().id,
                    lat: c.latitude, lon: c.longitude))
        }}} else {

        // ## NEED UPDATE ## \\

        VStack(spacing: 16) {

        Image("logo")
        Text("PlatterPals")
            .font(.custom("Lobster", size: 50))

        Text("An update to PlatterPals is here!")
            .font(.headline)

        HStack(spacing: 0) {
        Text("Download now from the ")
            .foregroundColor(.secondary)

        Link(destination: URL(string:
            "https://apps.apple.com/app/id1667418651")!) {
            Text("App Store.")
        }}}
        .foregroundColor(.pink)
        .background {
            Back()
        }}}}}

// ## PILL BUTTON ## \\
struct Glow: View {
    var text: String
    var body: some View {
        let spark = Image(systemName: "sparkles")

        // ## SHOW TEXT ## \\

        Text("\(spark) \(text) \(spark)")
            .font(.headline)
            .foregroundColor(.pink)
            .frame(width: UIwidth-32, height: 50)
            .overlay(Capsule().stroke(.pink, lineWidth: 3))
            .shadow(color: .pink, radius: 8)
            .padding(.bottom, 16)
    }
}
// ## MARKDOWNS ## \\
struct Blank: View {

    var label: String
    var secure = false
    @Binding var text: String

    var body: some View {
        VStack {

            // ## TEXT LOGIC ## \\

            if secure {
                SecureField(label, text: $text)
            } else {
                TextField(label, text: $text)
            }
            if label == "Username" {
                Max(count: 32, text: $text)
            }
        }
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
        .submitLabel(.done)
    }
}
// ## MAX CHARS ## \\
struct Max: View {

    var count: Int
    @Binding var text: String
    var text2 = ""

    var body: some View {
        if text.count > 32 {
            Text("32 chars max")
                .foregroundColor(.secondary)
                .onChange(of: text) {_ in
                    text = String(text.dropLast())
                }
        } else if text2.count > 32 {
            Text("32 chars max")
                .foregroundColor(.secondary)
        }}}
