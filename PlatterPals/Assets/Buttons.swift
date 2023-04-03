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

    var id = ""
    var path: Int
    var image: String
    @State var showView = false
    @EnvironmentObject var DM: DataManager

    var body: some View {
        if showView {
            Update(id: id)
                .environmentObject(DM)
        } else {
            content
        }
    }
    var content: some View {
        Button {
            withAnimation {
                showView = true
            }
        } label: {
            Text("\(Image(systemName: image))")
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
        }
        .background(.pink)
        .cornerRadius(40)
    }
}
