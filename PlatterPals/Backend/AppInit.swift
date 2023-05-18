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
            Orders()
                .tabItem {
                    Image(systemName: "menucard")
                }.tag(1)
            Chats()
                .tabItem {
                    Image(systemName: "message")
                }.tag(2)
            Home()
                .tabItem {
                    Image(systemName: "house")
                }.tag(3)
            Suggest()
                .tabItem {
                    Image(systemName: "fork.knife")
                }.tag(4)
            MyProfile(id: DM.my().id)
                .tabItem {
                    Image(systemName: "person")
                }.tag(5)
        }
        .environmentObject(DM)
    }
}
