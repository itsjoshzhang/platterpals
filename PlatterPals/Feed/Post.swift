import SwiftUI

struct Post: View {
    
    @State var user: String
    @State var image: UIImage
    @State var text: String
    @State var comment: String = ""
    @State var showProfile = false
    
    @State var result = 0
    @State var offset = 0.0
    @State var size = 1.0
    
    var like = Image(systemName: "heart.fill")
    var dislike = Image(systemName: "heart.slash.fill")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            Button {
                showProfile = true
            } label: {
                HStack {
                    Image(userData[user] ?? "logo")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 40.0)
                    Text(user)
                        .font(.headline)
                }
                .padding(.horizontal, 16.0)
            }
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .gesture(
                        DragGesture(minimumDistance: 50.0)
                            .onChanged { swipe in
                                offset = swipe.translation.width
                                size = 1.0
                            }
                            .onEnded { swipe in
                                withAnimation(.easeIn(duration: 0.25)) {
                                    result = Int(swipe.translation.width)
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
            HStack {
                TextField("Write a comment", text: $comment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button {
                    if result > 0 { result = 0
                    } else { result = 1; showProfile = true }
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
            }
            .padding(.horizontal, 16.0)
        }
        .fullScreenCover(isPresented: $showProfile) {
            FeedProfile(user: user)
        }
    }
}
struct Post_Previews: PreviewProvider {
    static var previews: some View {
        Feed()
    }
}
