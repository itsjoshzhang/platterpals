import SwiftUI
import Firebase

// ## APP VERSION ## \\
public let VERSION = 5
// MARK: - CHANGE THIS

@main
// ## START APP ## \\
struct AppInit: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
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
        TabView(selection: $page) {

        // ## SHOW PAGES ## \\

        Orders(AI: $page)
            .tabItem {
                Image(systemName: "menucard")
            }.tag(0)
        Chats()
            .environmentObject(MD)
            .tabItem {
                Image(systemName: "message")
            }.tag(1)
        Home(userList: DM.userList.shuffled())
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
            }}}}}}
