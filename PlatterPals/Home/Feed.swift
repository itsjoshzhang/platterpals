import SwiftUI

struct Feed: View {
	@State var showNewPost = false
	
	var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(.vertical) {
                    BigButton(text: "What should I order today?",
                        route: "suggests")
                    
                    LazyVStack(alignment: .leading, spacing: 10.0) {
                        Post(user: "Saira", food: "lasagna")
                        Post(user: "Josh", food: "tacos")
                        Post(user: "Albert", food: "salmon")
                        Post(user: "Saathvik", food: "gnocchi")
                    }
                    .padding(.horizontal, 20.0)
                }
                VStack { Spacer()
                    HStack { Spacer()
                        CircleButton(image: "wand.and.stars",
                            route: "suggests")
                    }
                }
            }
            .navigationTitle("Platter Pals")
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
    var user: String
    var food: String
    
    var body: some View {
        Divider()
        HStack(spacing: 16.0) {
            
            Image(user)
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 40.0)

            Button {
                showProfile = true
            } label: {
                Text(user)
                    .font(.headline)
            }
        }
        .fullScreenCover(isPresented: $showProfile) {
            FeedProfile(user: user)
        }
        Image(food)
            .resizable()
            .scaledToFit()
        HStack {
            Image(systemName: "heart")
            Image(systemName: "message")
            Image(systemName: "paperplane")
        }
        Text("Had this \(food) today, tasted just fantastic!")
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
