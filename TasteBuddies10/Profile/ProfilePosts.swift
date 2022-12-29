import SwiftUI

struct ProfilePosts: View {
    
    var user: String
    @State private var showNewPost = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                
                LazyVStack(alignment: .leading, spacing: 10.0) {
                    Post(user: user, food: "lasagna")
                    Post(user: user, food: "tacos")
                    Post(user: user, food: "salmon")
                    Post(user: user, food: "gnocchi")
                }
                .padding(.horizontal, 20.0)
            }
            .navigationTitle("\(user)'s Posts")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("\(Image(systemName: "chevron.backward")) Back") {
                        dismiss()
                    }
                }
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
struct ProfilePosts_Previews: PreviewProvider {
	static var previews: some View {
        ProfilePosts(user: "Josh")
	}
}
