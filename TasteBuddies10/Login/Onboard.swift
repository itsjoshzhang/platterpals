import SwiftUI

struct Onboard: View {
    var body: some View {
        TabView {
            OnboardView(image: "screen1",
                        title: "Welcome to Taste Buddies!",
                        caption: "Get food suggestions from trained AI software and find friends who have similar taste buds.")
            OnboardView(image: "screen2",
                        title: "Can't decide what to eat?",
                        caption: "Let our algorithm choose for you. Just upload your DoorDash info and follow some friends!")
            OnboardView(image: "screen3",
                        title: "Go find your Taste Buddy!",
                        caption: "We've made it easy to filter the foods you like. Just swipe left to remove and right to approve!",
                        showButton: true)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}
struct OnboardView: View {
    
    var image: String
    var title: String
    var caption: String
    @State var showButton = false
    @State private var showFeed = false
    
    var body: some View {
        VStack(spacing: 16.0) {
            
            Image(image)
                .resizable()
                .scaledToFit()
                .foregroundColor(.pink)
                .frame(height: 350.0)
            
            Text(title)
                .font(.title).bold()
                .foregroundColor(.pink)
            
            Text(caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            if showButton {
                Button("Get Started") {
                    showFeed = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(.horizontal, 16.0)
        .fullScreenCover(isPresented: $showFeed) {
            MyTabView()
        }
    }
}
struct Onboard_Previews: PreviewProvider {
    static var previews: some View {
        Onboard()
    }
}
