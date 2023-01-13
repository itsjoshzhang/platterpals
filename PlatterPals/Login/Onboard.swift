import SwiftUI
import Firebase

struct Onboard: View {
    
    @State var loggedIn = false
    @StateObject var dm = DataManager()
    
    var body: some View {
        if loggedIn {
            withAnimation {
                MyTabView()
                    .environmentObject(dm)
            }
        } else {
            content
        }
    }
    var content: some View {
        TabView {
            OnboardView(image: "screen1",
                        title: "Welcome to Platter Pals!",
                        caption: "Get food suggestions from trained AI software and find friends who have similar taste buds.")
            OnboardView(image: "screen2",
                        title: "Can't decide what to eat?",
                        caption: "Let our algorithm choose for you. Just upload your DoorDash info and follow some friends!")
            OnboardView(image: "screen3",
                        title: "Go find your Platter Pal!",
                        caption: "We've made it easy to filter the foods you like. Just swipe left to remove and right to approve!",
                        showButton: true)
            .environmentObject(dm)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                loggedIn = user != nil
            }
        }
    }
}
struct OnboardView: View {
    
    var image: String
    var title: String
    var caption: String
    
    @State var showButton = false
    @State var showLogin = false
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        VStack(spacing: 20.0) {
            
            Image(image)
                .resizable()
                .scaledToFit()
                .foregroundColor(.pink)
            
            Text(title)
                .font(.title).bold()
                .foregroundColor(.pink)
            
            Text(caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            if showButton {
                Button("Get started") {
                    showLogin = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(.horizontal, 16.0)
        .fullScreenCover(isPresented: $showLogin) {
            Signup()
                .environmentObject(dm)
        }
    }
}
struct Onboard_Previews: PreviewProvider {
    static var previews: some View {
        Onboard()
    }
}
