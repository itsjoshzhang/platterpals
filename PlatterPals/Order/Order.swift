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
                    
                    if images.count != 0 {
                        Image(uiImage: images[0])
                            .resizable()
                            .scaledToFit()
                        
                        HStack {
                            TextField("Send feedback", text: $comment)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Image(systemName: "heart")
                            Image(systemName: "heart.slash")
                        }
                        BigButton(text: texts[0], route: "suggests")
                    }
                }
                Button("Order with DoorDash") {
                    showAction = true
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 20.0)
            .onAppear {
                retrieveImages()
            }
            .navigationTitle("Found Your Food!")
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
                            if images.count == 0 {
                                images.append(image)
                                texts.append(document["text"] as! String)
                            }}}}}}}}


struct Order_Previews: PreviewProvider {
    static var previews: some View {
        Order()
    }
}
