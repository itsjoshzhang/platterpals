import SwiftUI
import Firebase

struct Onboard: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        TabView {
            OnboardView(image: "screen1",
                        title: "Welcome to PlatterPals!",
                        caption: "Get food suggestions from intelligent AI software and find friends who have similar taste buds.")
            OnboardView(image: "screen2",
                        title: "Can't decide what to eat?",
                        caption: "Let our algorithm choose for you. Simply sync your DoorDash account and follow some friends!")
            OnboardView(image: "screen3",
                        title: "Go find your Platter Pal!",
                        caption: "We've made it easy to find the people you like. Just swipe left to remove and right to approve!",
                        showButton: true)
            .environmentObject(dm)
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
    @State var showFeed = false
    
    @Environment(\.dismiss) var dismiss
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
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(10.0)
    }
}
struct Onboard_Previews: PreviewProvider {
    static var previews: some View {
        Onboard()
            .environmentObject(DataManager())
    }
}
