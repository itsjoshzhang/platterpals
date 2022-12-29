import SwiftUI

struct Splash: View {
    @State private var showOnboard = false
    @State private var size = 0.9
    @State private var opacity = 0.0
    
    var body: some View {
        
        VStack {
            VStack {
                Image("logo")
                Text("Taste Buddies")
                    .bold()
                    .font(.custom("pacifico", size: 48))
                    .foregroundColor(.pink)
                
                ProgressView()
                    .tint(.pink)
                    .scaleEffect(2)
            }
            .scaleEffect(size)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 1.0)) {
                    size = 1.0
                    opacity = 1.0
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation {
                    showOnboard = true
                }
            }
        }
        .fullScreenCover(isPresented: $showOnboard) {
            Onboard()
        }
    }
}
struct Splash_Previews: PreviewProvider {
    static var previews: some View {
        Splash()
    }
}
