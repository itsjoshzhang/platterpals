import SwiftUI

struct BigButton: View {
    
    var text: String
    var route: String
    @State var showView = false
    
    var body: some View {
        Button {
            showView = true
        } label: {
            Text("\(Image(systemName: "sparkles")) \(text) \(Image(systemName: "sparkles"))")
                .font(.headline)
                .foregroundColor(.pink)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20.0)
        }
        .overlay(Capsule(style: .continuous)
            .stroke(.pink, lineWidth: 3))
        .shadow(color: .pink, radius: 8, x: 0, y: 8)
        .padding(20.0)
        
        .fullScreenCover(isPresented: $showView) {
            if route == "suggests" {
                Suggests()
            } else if route == "splash" {
                SplashOrder()
            } else if route == "feed" {
                Feed()
            }
        }
    }
}
struct CircleButton: View {
    
    var image: String
    var route: String
    @State var showView = false
    
    var body: some View {
        Button {
            showView = true
        } label: {
            Text("\(Image(systemName: image))")
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(width: 80, height: 80)
        }
        .background(.pink)
        .cornerRadius(80)
        .shadow(color: .pink, radius: 8, x: 0, y: 8)
        .padding(20.0)
        
        .fullScreenCover(isPresented: $showView) {
            if route == "suggests" {
                Suggests()
            } else if route == "maps" {
                Maps()
            }
        }
    }
}
struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            BigButton(text: "Hello, world!", route: "suggests")
            CircleButton(image: "wand.and.stars", route: "suggests")
        }
    }
}