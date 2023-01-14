import SwiftUI
import Firebase
import FirebaseStorage

struct Updates: View {
    
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
                    Text("No more updates")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("\(name)  -  Profile")
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
                
                let path = document["url"] as! String
                let user = document["user"] as! String
                let text = document["text"] as! String
                let storageRef = Storage.storage().reference()
                let fileRef = storageRef.child(path)
                
                fileRef.getData(maxSize: 10*1024*1024) { data, error in
                    if let data = data, let image = UIImage(data: data) {
                        
                        DispatchQueue.main.async {
                            if (name == user && !paths.contains(path)) {
                                paths.append(path)
                                users.append(user)
                                images.append(image)
                                texts.append(text)
                            }}}}}}}}


struct Updates_Previews: PreviewProvider {
	static var previews: some View {
        Updates(name: "Josh Z")
            .environmentObject(DataManager())
	}
}
