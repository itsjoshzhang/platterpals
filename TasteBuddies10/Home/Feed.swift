import SwiftUI

struct Feed: View {
	@State private var showNewPost = false
	
	var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                
                LazyVStack(alignment: .leading, spacing: 10.0) {
                    Post(user: "Saira", food: "lasagna")
                    Post(user: "Albert", food: "salmon")
                }
                .padding(.horizontal, 20.0)
            }
            .navigationTitle("Taste Buddies")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("New Post") {
                        showNewPost = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .fullScreenCover(isPresented: $showNewPost) {
                NewPost()
            }
        }
	}
}
struct Post: View {
    
    @State private var input: String = ""
    @State private var showProfile = false
    let user: String
    let food: String
    
    var body: some View {
        Divider()
        HStack(spacing: 16.0) {
            Image(user)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .frame(width: 40)
            Button {
                showProfile = true
            } label: {
                Text(user)
                    .font(.headline)
            }
        }
        .fullScreenCover(isPresented: $showProfile) {
            FeedProfile()
        }
        Image(food)
            .resizable()
            .aspectRatio(contentMode: .fit)
        HStack {
            Image(systemName: "heart")
            Image(systemName: "message")
            Image(systemName: "paperplane")
        }
        Text("Beef Lasagna - Pasta Bene")
        Text("13 mins ago")
            .foregroundColor(.secondary)
        
        TextField("Write a comment", text: $input)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}
struct Feed_Previews: PreviewProvider {
	static var previews: some View {
        Feed()
	}
}
