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
                ScrollView(.vertical) {
                LazyVStack(spacing: 16.0) {
                BigButton(text: "Let's order something!", route: "suggests")

                ForEach(0 ..< images.count, id: \.self) { i in
                    Post(user: users[i], image: images[i], text: texts[i])
                }
                }
                }
                VStack { Spacer()
                    HStack { Spacer()
                        CircleButton(image: "wand.and.stars", route: "suggests")
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        paths = []
                        users = []
                        images = []
                        texts = []
                        retrieveImages()
                    } label: {
                        Image(systemName: "clock.arrow.2.circlepath")
                    }
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


struct Feed_Previews: PreviewProvider {
	static var previews: some View {
        MyTabView()
	}
}
