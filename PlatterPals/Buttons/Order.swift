import SwiftUI
import Firebase
import FirebaseStorage

struct Order: View {
    
    @State var ids = [String]()
    @State var images = [UIImage]()
    @State var texts = [String]()
    @State var comment = ""
    @State var showFeed = false
    @State var showSync = false
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 16.0) {
                    
                    if images.count == 1 {
                        BigButton(text: texts[0], route: "sync")
                            .environmentObject(dm)
                        
                        Post(id: ids[0], user: "PlatterPals", image: images[0], text: "Send us feedback below:")
                            .environmentObject(dm)
                    }
                    Spacer()
                }
                Button("Order food") {
                    showSync = true
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Your Order:")
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
            .fullScreenCover(isPresented: $showSync) {
                Sync()
                    .environmentObject(dm)
            }
        }
    }
    func retrieveImages() {
        let db = Firestore.firestore()
        db.collection("images").getDocuments { snapshot, error in
            for document in snapshot!.documents {
                
                let path = document["url"] as! String
                let text = document["text"] as! String
                let storageRef = Storage.storage().reference()
                let fileRef = storageRef.child(path)
                
                fileRef.getData(maxSize: 10*1024*1024) { data, error in
                    if let data = data, let image = UIImage(data: data) {
                        
                        DispatchQueue.main.async {
                            if images.count == 0 {
                                images.append(image)
                                texts.append(text)
                                ids.append(document.documentID)
                            }}}}}}}}


struct Order_Previews: PreviewProvider {
    static var previews: some View {
        Order()
            .environmentObject(DataManager())
    }
}
