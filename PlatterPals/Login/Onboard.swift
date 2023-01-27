import SwiftUI
import Firebase

struct Onboard: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        TabView {
            OnboardView(image: "screen1",
                        title: "Welcome to PlatterPals!",
                        caption: "Get food suggestions from trained AI software and find friends who have similar taste buds.")
            OnboardView(image: "screen2",
                        title: "Can't decide what to eat?",
                        caption: "Let our algorithm choose for you. Just upload your DoorDash info and follow some friends!")
            OnboardView(image: "screen3",
                        title: "Go find your Platter Pal!",
                        caption: "We've made it easy to find the people you like. Just swipe left to remove and right to approve!",
                        showButton: true)
            .environmentObject(dm)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                withAnimation {
                    if (dm.user.name != "Log Out") {
                        dismiss()
                    }}}}}}


struct OnboardView: View {
    
    var image: String
    var title: String
    var caption: String
    
    @State var showButton = false
    @State var showFeed = false
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        VStack(spacing: 16.0) {
            
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
                    showFeed = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(.horizontal, 16.0)
        .fullScreenCover(isPresented: $showFeed) {
            Signup()
                .environmentObject(dm)
        }
    }
}
struct Onboard_Previews: PreviewProvider {
    static var previews: some View {
        Onboard()
            .environmentObject(DataManager())
    }
}
