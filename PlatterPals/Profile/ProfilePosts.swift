import SwiftUI
import Firebase
import FirebaseStorage

struct ProfilePosts: View {
    
    @State var name: String
    @State var paths = [String]()
    @State var users = [String]()
    @State var images = [UIImage]()
    @State var texts = [String]()
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16.0) {
                    Spacer()
                    ForEach(0 ..< images.count, id: \.self) { i in
                        Post(user: users[i], image: images[i], text: texts[i])
                            .environmentObject(dm)
                    }
                    Spacer()
                    Text("No more posts")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("\(name)  -  Posts")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("\(Image(systemName: "chevron.backward")) Back") {
                        dismiss()
                    }
                }
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
                
                let storageRef = Storage.storage().reference()
                let path = document["url"] as! String
                let fileRef = storageRef.child(path)
                let user = document["user"] as! String
                
                fileRef.getData(maxSize: 10*1024*1024) { data, error in
                    if let data = data, let image = UIImage(data: data) {
                        
                        DispatchQueue.main.async {
                            if name == user && !paths.contains(path) {
                                paths.append(path)
                                
                                images.append(image)
                                users.append(name)
                                texts.append(document["text"] as! String)
                            }}}}}}}}


struct ProfilePosts_Previews: PreviewProvider {
	static var previews: some View {
        ProfilePosts(name: "Josh Z")
            .environmentObject(DataManager())
	}
}
