// File: checked

import SwiftUI

struct Update: View {
    
    var id: String
    @State var size = 1.0
    @State var offset = 0.0
    @State var avatar: UIImage?
    @State var profile: UIImage?

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
            let user = DM.user(id: id)

            Button {
                showProf = true
            } label: {
                HStack {
                    RoundPic(image: avatar, width: 80)

                    Text(user.name)
                        .font(.headline)
                    Spacer()

                    Button("...") {
                        showAlert = true
                    }
                    .alert("Profile settings", isPresented: $showAlert) {

                        if user.id == DM.my().id {
                            Button("Delete profile", role: .destructive) {

                                DM.delImage(path: "profiles")
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
                if let profile = profile {
                    Image(uiImage: profile)
                        .resizable()
                        .scaledToFit()
                        .frame(height: UIheight)
                        .clipped()

                        .gesture(DragGesture(minimumDistance: UIwidth / 4)
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
                }
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
                Text(user.city)
                Text(user.text)

                Text("\(Image(systemName: "heart.fill")) \(user.views)")
            }
            .padding(.horizontal, 16)
        }
        .onAppear {
            let id = DM.user(id: id).id

            avatar = DM.getImage(id: id, path: "avatars")
            profile = DM.getImage(id: id, path: "profiles")
        }
        .fullScreenCover(isPresented: $showProf) {
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
