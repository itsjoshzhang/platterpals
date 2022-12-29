import SwiftUI

@main
struct AppInit: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            Splash()
        }
    }
}
struct MyTabView: View {
    @State private var selection = 2
    
    var body: some View {
        TabView(selection: $selection) {
            Chats()
                .tabItem {
                    Image(systemName: "message")
                    Text("Chats")
                }
                .tag(1)
            Feed()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(2)
            Profile()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
                .tag(3)
        }
    }
}
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UIView.appearance().tintColor = .systemPink
        return true
    }
}
