import SwiftUI

struct BigButton: View {

    var path: Int
    var text: String
    @State var showView = false

    @EnvironmentObject var DM: DataManager

    var body: some View {
        Button {
            showView = true
        } label: {
            Text(text)
                .font(.headline)
                .foregroundColor(.pink)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
        }
        .overlay(Capsule(style: .continuous)
        .stroke(.pink, lineWidth: 3))
        .shadow(color: .pink, radius: 6, x: 0, y: 6)
        .padding(20)

        .fullScreenCover(isPresented: $showView) {
            if path == 1 {
                Suggest()
                    .environmentObject(DM)
            } else {
                Splash(first: false)
                    .environmentObject(DM)
            }
        }
    }
}
struct CircleButton: View {
    
    var path: Int
    var image: String
    @State var showView = false
    @EnvironmentObject var DM: DataManager
    
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
        .shadow(color: .pink, radius: 6, x: 0, y: 6)
        .padding(20)
        
        .fullScreenCover(isPresented: $showView) {
            if path == 1 {
                Maps()
                    .environmentObject(DM)
            } else if path == 2 {
                Suggest()
                    .environmentObject(DM)
            } else {
                Upload()
                    .environmentObject(DM)
            }
        }
    }
}
struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
//            BigButton(path: 1, text: "Hello, world!")
//                .environmentObject(DataManager())
            
            CircleButton(path: 2, image: "wand.and.stars")
                .environmentObject(DataManager())
        }
    }
}
