import SwiftUI
import Firebase
import FirebaseStorage

struct Order: View {

    @State var images = [UIImage]()
    @State var texts = [String]()
    @State var comment = ""
    
    @State var showFeed = false
    @State var showAction = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        if showFeed {
            withAnimation {
                MyTabView()
            }
        } else {
            content
        }
    }
    var content: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 16.0) {
                    
                    if images.count == 1 {
                        Post(user: "PlatterPals", image: images[0], text: "Send us feedback below:")
                        
                        BigButton(text: texts[0], route: "suggests")
                    }
                }
                Button("Order with DoorDash") {
                    showAction = true
                }
                .buttonStyle(.borderedProminent)
            }
            .onAppear {
                retrieveImages()
            }
            .navigationTitle("Your Order:")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("\(Image(systemName: "chevron.backward")) Back") {
                        showFeed = true
                    }
                }
            }
        }
        .actionSheet(isPresented: $showAction) {
            ActionSheet(title: Text("Leave App"),
                        buttons: [
                            .default(Text("Log in to DoorDash")),
                            .destructive(Text("View restaurant website")),
                            .cancel(Text("Cancel"))]
            )
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
                            if images.count < 1 {
                                images.append(image)
                                texts.append(document["text"] as! String)
                            }}}}}}}}


struct Order_Previews: PreviewProvider {
    static var previews: some View {
        Order()
    }
}
