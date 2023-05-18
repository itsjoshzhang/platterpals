import SwiftUI
import Firebase

@main
struct AppInit: App {
    init() {
        FirebaseApp.configure()
        UIView.appearance().tintColor = .systemPink
    }
    var body: some Scene {
        WindowGroup {
            Splash()
        }
    }
}
struct MyTabView: View {

    @State var tag = 3
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        TabView(selection: $tag) {
            Chats()
                .tabItem {
                    Image(systemName: "message")
                }.tag(1)
            Suggest()
                .tabItem {
                    Image(systemName: "fork.knife")
                }.tag(2)
            Home()
                .tabItem {
                    Image(systemName: "house")
                }.tag(3)
            Orders()
                .tabItem {
                    Image(systemName: "menucard")
                }.tag(4)
            UserProf(id: DM.my().id)
                .tabItem {
                    Image(systemName: "person")
                }.tag(5)
        }
        .environmentObject(DM)
    }
}
