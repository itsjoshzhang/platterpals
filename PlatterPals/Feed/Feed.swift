import SwiftUI
import Firebase
import FirebaseStorage

struct Feed: View {
    
    @State var ids = [String]()
    @State var paths = [String]()
    @State var users = [String]()
    @State var images = [UIImage]()
    @State var texts = [String]()
    
    @State var showNewPost = false
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 16.0) {
                        BigButton(text: "Let's order something!", route: "suggests")
                            .environmentObject(dm)
                        
                        ForEach(0 ..< images.count, id: \.self) { i in
                            Post(id: ids[i], user: users[i], image: images[i], text: texts[i])
                                .environmentObject(dm)
                        }
                        Spacer()
                        Text("No more profiles")
                            .foregroundColor(.secondary)
                        Spacer()
                        Spacer()
                    }
                }
                VStack { Spacer()
                    HStack { Spacer()
                        CircleButton(image: "wand.and.stars", route: "suggests")
                            .environmentObject(dm)
                    }
                }
            }
            .navigationTitle("PlatterPals")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("\(Image(systemName: "square.and.arrow.up")) Profile") {
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
                        Image(systemName: "clock.arrow.circlepath")
                    }
                }
            }
            .fullScreenCover(isPresented: $showNewPost) {
                NewPost()
                    .environmentObject(dm)
            }
            .onAppear {
                retrieveImages()
            }
        }
    }
    func retrieveImages() {
        let db = Firestore.firestore()
        db.collection("profiles").getDocuments { snapshot, error in
            for document in snapshot!.documents {
                
                let path = document["url"] as! String
                let storageRef = Storage.storage().reference()
                let fileRef = storageRef.child(path)
                
                fileRef.getData(maxSize: 10*1024*1024) { data, error in
                    if let data = data, let image = UIImage(data: data) {
                        
                        DispatchQueue.main.async {
                            if !paths.contains(path) {
                                
                                paths.append(path)
                                images.append(image)
                                users.append(document["user"] as! String)
                                texts.append(document["text"] as! String)
                                ids.append(document.documentID)
                            }}}}}}}}


struct Feed_Previews: PreviewProvider {
	static var previews: some View {
        MyTabView()
            .environmentObject(DataManager())
	}
}
