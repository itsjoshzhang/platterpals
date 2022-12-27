import SwiftUI

@main
struct TasteBuddies: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            TabView {
                Chats()
                    .tabItem {
                        Image(systemName: "message")
                        Text("Chats")
                    }
                Feed()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                Profile()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Profile")
                    }}}}}


class AppDelegate: UIResponder, UIApplicationDelegate {
    
	func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
		UIView.appearance().tintColor = .systemPink
		return true
	}
}
