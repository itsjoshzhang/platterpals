import SwiftUI
import Firebase

// ## APP VERSION ## \\
private let VERSION = 0
// MARK: - CHANGE THIS

@main
// ## START APP ## \\
struct AppInit: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        // FirebaseApp.configure()
        UIView.appearance().tintColor = .systemPink
    }
    var body: some Scene {
        WindowGroup {
            Splash()
        }}}

struct MyTabView: View {

    // ## TRACK INFO ## \\
    @State var id = "!"
    @State var page = 2
    @State var showGuide = false

    @EnvironmentObject var DM: DataManager
    @EnvironmentObject var MD: MapsData

    var body: some View {
        Group {
        if DM.version == VERSION {

        // ## NO UPDATE ## \\

        TabView(selection: $page) {
        Orders()
            .tabItem {
                Image(systemName: "menucard")
            }.tag(0)
        Chats()
            .environmentObject(MD)
            .tabItem {
                Image(systemName: "message")
            }.tag(1)
        Home()
            .tabItem {
                Image(systemName: "house")
            }.tag(2)
        Suggest()
            .tabItem {
                Image(systemName: "fork.knife")
            }.tag(3)
        MyProfile()
            .tabItem {
                Image(systemName: "person")
            }.tag(4)
        }
        // ## MODIFIERS ## \\

        .environmentObject(DM)
        .sheet(isPresented: $showGuide) {
            Guide(page: id == "!" ? 0: 4)
                .environmentObject(DM)
        }
        .onAppear {
            id = DM.my().id
            showGuide = !DM.my().prof

            if id != "!" {
                if let c = MD.LM?.location?.coordinate {
                    DM.sendPin(pin: Location(id: id,
                        lat: c.latitude, lon: c.longitude))
                }}}

        // ## NEED UPDATE ## \\

        } else {
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
