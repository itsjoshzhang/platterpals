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
        VStack(spacing: 16.0) {
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
    
    @State var size = 0.9
    @State var opacity = 0.0
    @State var progress = 0.0
    @State var showSuggest = false
    
    var body: some View {
        if showSuggest {
            withAnimation {
                Order()
            }
        } else {
            content
        }
    }
    var content: some View {
        VStack(spacing: 16.0) {
            
            Image("logo")
            Text("Platter Pals")
                .font(.custom("Lobster", size: 48.0))
                .foregroundColor(.pink)
            
            Text("Loading the perfect dish...")
                .font(.headline)
                .foregroundColor(.pink)
            
            ProgressView()
                .tint(.pink)
                .scaleEffect(2.0)
                .padding(20.0)
        }
        .scaleEffect(size)
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeIn(duration: 1.0)) {
                size = 1.0
                opacity = 1.0
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation {
                    showSuggest = true
                }}}}}


struct Splash_Previews: PreviewProvider {
    static var previews: some View {
        Splash()
        SplashOrder()
    }
}
