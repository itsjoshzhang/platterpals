import SwiftUI
import Firebase

@main
struct AppInit: App {
    
    @StateObject var dataManager = DataManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            Splash()
        }
    }
}
struct MyTabView: View {
    @State private var tag = 2
    
    var body: some View {
        TabView(selection: $tag) {
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
