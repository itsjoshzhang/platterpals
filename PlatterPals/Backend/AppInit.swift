import SwiftUI
import Firebase

// MARK: - CHANGE THIS
public let VERSION = 0

@main
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

    @State var id = "!"
    @State var page = 2
    @State var showGuide = false

    @EnvironmentObject var DM: DataManager
    @EnvironmentObject var MD: MapsData

    var body: some View {
        Group {
        TabView(selection: $page) {

        Orders(pageDir: $page)
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
        Select()
            .tabItem {
                Image(systemName: "fork.knife")
            }.tag(3)
        MyProfile()
            .tabItem {
                Image(systemName: "person")
            }.tag(4)
        }
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
