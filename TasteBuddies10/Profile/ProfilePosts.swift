import SwiftUI

struct ProfilePosts: View {
    
    @State private var showNewPost = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                
                LazyVStack(alignment: .leading, spacing: 10.0) {
                    Post(user: "Josh", food: "tacos")
                    Post(user: "Josh", food: "gnocchi")
                }
                .padding(.horizontal, 20.0)
            }
            .navigationTitle("Your Posts")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("< Back") {
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
        ProfilePosts()
	}
}
