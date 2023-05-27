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
        FirebaseApp.configure()
        UIView.appearance().tintColor = .systemPink
    }
    var body: some Scene {
        WindowGroup {
            Splash()
        }}}

struct MyTabView: View {

    // ## TRACK INFO ## \\
    @State var tag = 3
    @State var showGuide = false

    @StateObject var MD = MapsData()
    @EnvironmentObject var DM: DataManager

    var body: some View {
        Group {
            let my = DM.my()
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
        // ## MODIFIERS ## \\

        .environmentObject(DM)
        .sheet(isPresented: $showGuide) {
            Guide(tag: my.prof)
                .environmentObject(DM)
        }
        .onAppear {
            showGuide = my.prof >= 0

            if let c = MD.LM?.location?.coordinate {
                DM.sendPin(pin: Location(id: my.id,
                    lat: c.latitude, lon: c.longitude))

        // ## NEED UPDATE ## \\

        }}} else {
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
