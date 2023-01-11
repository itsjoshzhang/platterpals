import SwiftUI
import Firebase
import FirebaseStorage

struct Feed: View {
    
    @State var showNewPost = false
    @State var paths = [String]()
    @State var users = [String]()
    @State var images = [UIImage]()
    @State var texts = [String]()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0.0) {
                    BigButton(text: "What should I order today?", route: "suggests")
                    List {
                        ForEach((0 ..< images.count).reversed(), id: \.self) { i in
                            Post(user: users[i], image: images[i], text: texts[i])
                        }
                        .listRowInsets(.init())
                    }
                    .listStyle(.plain)
                    .refreshable {
                        retrieveImages()
                    }
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
                    Button("New post") {
                        showNewPost = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .fullScreenCover(isPresented: $showNewPost) {
                NewPost()
            }
            .onAppear {
                retrieveImages()
            }
        }
    }
    func retrieveImages() {
        let db = Firestore.firestore()
        db.collection("images").getDocuments { snapshot, error in
            for document in snapshot!.documents {
                
                let storageRef = Storage.storage().reference()
                let path = document["url"] as! String
                let fileRef = storageRef.child(path)
                
                fileRef.getData(maxSize: 10*1024*1024) { data, error in
                    if let data = data, let image = UIImage(data: data) {
                        
                        DispatchQueue.main.async {
                            if !paths.contains(path) {
                                paths.append(path)
                                
                                images.append(image)
                                users.append(document["user"] as! String)
                                texts.append(document["text"] as! String)
                            }}}}}}}}


struct Post: View {
    
    
    @State var user: String
    @State var image: UIImage
    @State var text: String
    @State var comment: String = ""
    @State var showProfile = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            Button {
                showProfile = true
            } label: {
                HStack {
                    Image(userData[user]!)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 40.0)
                    
                    Text(user)
                        .font(.headline)
                }
                .padding(.horizontal, 16.0)
            }
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
            
            Section {
                Text(text)
                HStack {
                    TextField("Write a comment", text: $comment)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Image(systemName: "heart")
                    Image(systemName: "heart.slash")
                }
            }
            .padding(.horizontal, 16.0)
        }
        .padding(.vertical, 16.0)
        .fullScreenCover(isPresented: $showProfile) {
            FeedProfile(user: user)
        }
    }
}

struct Feed_Previews: PreviewProvider {
	static var previews: some View {
        MyTabView()
	}
}
