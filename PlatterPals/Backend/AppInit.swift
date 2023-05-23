import SwiftUI
import Firebase

// ## APP VERSION ## \\
private let version = 0
// MARK: - CHANGE THIS

@main
struct AppInit: App {
    init() {
        FirebaseApp.configure()
        UIView.appearance().tintColor = .systemPink
    }
    var body: some Scene {
        WindowGroup {
            Splash()
        }}}

struct MyTabView: View {

    @State var tag = 3
    @StateObject var MD = MapsData()
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        Group {
        if DM.version == version {
            TabView(selection: $tag) {
            Orders()
                .tabItem {
                    Image(systemName: "menucard")
                }
                .tag(1)
            Chats()
                .environmentObject(MD)
                .tabItem {
                    Image(systemName: "message")
                }
                .tag(2)
            Home()
                .tabItem {
                    Image(systemName: "house")
                }
                .tag(3)
            Suggest()
                .environmentObject(MD)
                .tabItem {
                    Image(systemName: "fork.knife")
                }
                .tag(4)
            MyProfile(id: DM.my().id)
                .tabItem {
                    Image(systemName: "person")
                }
                .tag(5)
            }
            .environmentObject(DM)
        } else {
            ZStack {
            Back()
            VStack(spacing: 16) {

            Image("logo")
            Text("PlatterPals")
                .font(.custom("Lobster", size: 50))

            Text("A new version of PlatterPals is available!")
                .font(.headline)

            HStack(spacing: 0) {
            Text("Download it from the App Store at ")
                .foregroundColor(.secondary)

            Link(destination: URL(string:
                "https://apps.apple.com/app/id1667418651")!) {
                Text("this link")
                    .foregroundColor(.blue)
                    .underline()
            }}}
            .foregroundColor(.pink)
            }}}}}
