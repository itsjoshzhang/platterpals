import SwiftUI

struct Splash: View {
    
    @State var size = 0.9
    @State var opacity = 0.0
    @State var showLogin = false
    
    var body: some View {
        if showLogin {
            withAnimation {
                Onboard()
            }
        } else {
            content
        }
    }
    var content: some View {
        VStack {
            VStack {
                Image("logo")
                
                Text("Platter Pals")
                    .font(.custom("Lobster", size: 48.0))
                    .foregroundColor(.pink).bold()
                
                ProgressView()
                    .tint(.pink)
                    .scaleEffect(2.0)
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
                    showLogin = true
                }
            }
        }
    }
}
struct SplashOrder: View {
    
    @State private var showSuggest = false
    @State private var size = 0.9
    @State private var opacity = 0.0
    @State private var progress = 0.0
    
    var timer = Timer.publish(
        every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Image("logo")
            
            Text("Platter Pals")
                .font(.custom("Lobster", size: 48.0))
                .foregroundColor(.pink)
            
            Text("Loading the perfect dish...")
                .font(.headline)
                .foregroundColor(.pink)
            
            ProgressView(value: progress, total: 180.0)
                .padding()
                .background(.gray.opacity(0.25))
                .cornerRadius(8.0)
                .tint(.pink)
                .padding()
            
                .onReceive(timer) { _ in
                    if progress < 300 {
                        progress += 1
                    } else {
                        showSuggest = true
                    }
                }
        }
        .scaleEffect(size)
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeIn(duration: 1.0)) {
                self.size = 1.0
                self.opacity = 1.0
            }
        }
        .fullScreenCover(isPresented: $showSuggest) {
            Order()
        }
    }
}
struct Splash_Previews: PreviewProvider {
    static var previews: some View {
        Splash()
        SplashOrder()
    }
}
