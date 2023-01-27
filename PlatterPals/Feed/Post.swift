import SwiftUI

struct Post: View {
    
    var id: String
    var user: String
    var image: UIImage
    var text: String
    @State var comment: String = ""
    @State var showComment = true
    
    @State var result = 0
    @State var offset = 0.0
    @State var size = 1.0
    @State var showProfile = false
    @State var hidePost = false
    
    @State var showAlert = false
    @EnvironmentObject var dm: DataManager
    var like = Image(systemName: "heart.fill")
    var dislike = Image(systemName: "heart.slash.fill")
    
    var body: some View {
        if hidePost {
            Button("Unhide profile") {
                withAnimation {
                    hidePost = false }}
        } else {
            content
        }
    }
    var content: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            Button {
                if user != "PlatterPals" {
                    showProfile = true
                }
            } label: {
                HStack {
                    Image(dm.fetchData(name: user, route: true))
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 40.0)
                    Text(user)
                        .font(.headline)
                    Spacer()
                    
                    if user == dm.user.name {
                        Button("...") {
                            showAlert = true
                        }
                        .alert("Delete update?", isPresented: $showAlert) {
                            Button("Delete", role: .destructive) {
                                dm.deleteData(id: id)
                            }
                            Button("Cancel", role: .cancel) {}
                        }
                    }
                }
                .padding(.horizontal, 16.0)
            }
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.width)
                    .clipped()
                    .gesture(
                        DragGesture(minimumDistance: 50.0)
                            .onChanged { swipe in
                                offset = swipe.translation.width
                                size = 1.0
                            }
                            .onEnded { swipe in
                                withAnimation(.easeIn(duration: 0.25)) {
                                    result = Int(swipe.translation.width)
                                    if user != "PlatterPals" {
                                        showProfile = (result > 0)
                                        hidePost = (result < 0)
                                    }
                                    size = 0.0
                                }
                            }
                    )
                like
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .foregroundColor(.pink)
                    .opacity(offset / 200.0)
                    .scaleEffect(size)
                dislike
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .foregroundColor(.white)
                    .opacity(offset / -200.0)
                    .scaleEffect(size)
            }
            Text(text)
                .padding(.horizontal, 16.0)
            if !showComment {
                Text("\(dm.user.name): \(comment)")
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 16.0)
            }
            HStack {
                Button {
                    if result > 0 { result = 0 } else { result = 1 }
                } label: {
                    if result > 0 { like.foregroundColor(.pink) } else {
                        Image(systemName: "heart")
                    }
                }
                Button {
                    if result < 0 { result = 0 } else { result = -1 }
                } label: {
                    if result < 0 { dislike.foregroundColor(.black) } else {
                        Image(systemName: "heart.slash")
                    }
                }
                if showComment {
                    TextField("Write a comment", text: $comment)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                Spacer()
                Button("\(Image(systemName: "paperplane"))") {
                    showComment.toggle()
                }
                .disabled(comment == "")
            }
            .padding(.horizontal, 16.0)
        }
        .fullScreenCover(isPresented: $showProfile) {
            FeedProfile(user: user)
                .environmentObject(dm)
        }
    }
}
struct Post_Previews: PreviewProvider {
    static var previews: some View {
        Feed()
            .environmentObject(DataManager())
    }
}
