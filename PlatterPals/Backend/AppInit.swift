// File: checked

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
            Splash(first: true)
        }
    }
}
struct MyTabView: View {
    
    @State var tag = 2
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        TabView(selection: $tag) {
            Chats()
                .tabItem {
                    Image(systemName: "message")
                    Text("Chats")
                }
                .tag(1)
            Home()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(2)
            Myself()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(3)
        }
        .environmentObject(DM)
    }
}
struct AppInit_Previews: PreviewProvider {
    static var previews: some View {
        MyTabView()
            .environmentObject(DataManager())
    }
}
