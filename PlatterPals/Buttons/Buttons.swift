import SwiftUI

struct BigButton: View {
    
    var text: String
    var route: String
    var user = ""
    @State var showView = false
    @EnvironmentObject var dm: DataManager
    
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
            .stroke(.pink, lineWidth: 3.0))
        .shadow(color: .pink, radius: 6.0, x: 0, y: 6.0)
        .padding(20.0)
        
        .fullScreenCover(isPresented: $showView) {
            if route == "suggests" {
                Suggests()
                    .environmentObject(dm)
            } else if route == "splash" {
                Splash2()
                    .environmentObject(dm)
            } else {
                Sync()
            }
        }
    }
}
struct CircleButton: View {
    
    var image: String
    var route: String
    @State var showView = false
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        Button {
            showView = true
        } label: {
            Text("\(Image(systemName: image))")
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(width: 80.0, height: 80.0)
        }
        .background(.pink)
        .cornerRadius(80.0)
        .shadow(color: .pink, radius: 6.0, x: 0, y: 6.0)
        .padding(20.0)
        
        .fullScreenCover(isPresented: $showView) {
            if route == "suggests" {
                Suggests()
                    .environmentObject(dm)
            } else if route == "maps" {
                Maps()
                    .environmentObject(dm)
            } else {
                Upload()
                    .environmentObject(dm)
            }
        }
    }
}
struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            BigButton(text: "Hello, world!", route: "suggests")
                .environmentObject(DataManager())
            CircleButton(image: "wand.and.stars", route: "suggests")
                .environmentObject(DataManager())
        }
    }
}
