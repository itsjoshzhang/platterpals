// File: checked

import SwiftUI

struct Update: View {
    
    var id: String
    @State var size = 1.0
    @State var offset = 0.0

    @State var showProf = false
    @State var hideProf = false
    @State var showAlert = false

    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        if hideProf {
            Button("Unhide profile") {
                withAnimation {
                    hideProf = false }}
        } else {
            content
        }
    }
    var content: some View {
        VStack(alignment: .leading, spacing: 16) {

            let profile = DM.prof(id: id)

            Button {
                showProf = true
            } label: {
                HStack {
                    Image(uiImage: DM.getImage(id: id, path: "avatars"))
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 40)

                    Text(DM.user().name)
                        .font(.headline)
                    Spacer()

                    Button("...") {
                        showAlert = true
                    }
                    .alert("Profile settings", isPresented: $showAlert) {

                        if id == DM.user().id {
                            Button("Delete profile", role: .destructive) {

                                DM.editProf(id: id, city: "", text: "", likes: 0)
                            }
                        } else {
                            Button("Report profile", role: .destructive) {
                                withAnimation {
                                    hideProf = true
                                }
                            }
                        }
                        Button("Cancel", role: .cancel) {}
                    }
                }
                .padding(.horizontal, 16)
            }
            ZStack {
                let ui = UIScreen.main.bounds

                Image(uiImage: DM.getImage(id: id, path: "profiles"))
                    .resizable()
                    .scaledToFit()
                    .frame(height: ui.height)
                    .clipped()

                    .gesture(DragGesture(minimumDistance: ui.width / 4)
                        .onChanged { swipe in
                            offset = swipe.translation.width
                            size = 1.0
                        }
                        .onEnded { swipe in
                            withAnimation(.easeIn(duration: 0.25)) {

                                if swipe.translation.width > 0 {
                                    showProf = true
                                } else {
                                    hideProf = true
                                }
                                size = 0.0
                            }
                        }
                    )
                Group {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .foregroundColor(.pink)
                        .opacity(offset / 200.0)

                    Image(systemName: "heart.slash.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .opacity(offset / -200.0)
                }
                .scaledToFit()
                .frame(width: 200)
                .scaleEffect(size)
            }
            Group {
                Text(profile.city)
                Text(profile.text)

                Text("\(Image(systemName: "heart.fill")) \(profile.likes)")
            }
            .padding(.horizontal, 16)
        }
        .sheet(isPresented: $showProf) {
            UserProf(id: id)
                .environmentObject(DM)
        }
    }
}
struct Update_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(DataManager())
    }
}
