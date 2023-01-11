import SwiftUI
import Firebase

struct User: Identifiable {
    var id: String
    var name: String
    var image: String
}

class DataManager: ObservableObject {
    @Published var users: [User] = []
    
    init() {
        fetchUsers()
    }
    func fetchUsers() {
        users.removeAll()
        let db = Firestore.firestore()
        db.collection("users").getDocuments { snapshot, error in

            for document in snapshot!.documents {
                let data = document.data()
                
                let id = data["id"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let image = data["image"] as? String ?? ""
                
                let user = User(id: id, name: name, image: image)
                self.users.append(user)
            }
        }
    }
        
    func addUser(id: String, name: String, image: String) {
        let db = Firestore.firestore()
        let ref = db.collection("users").document(id)
        ref.setData(["id": id, "name": name, "image": image])
    }
}
struct Users: View {
    
    @State var id = ""
    @State var name = ""
    @State var image = ""
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        NavigationStack {
            List(dm.users) { user in
                HStack(spacing: 16.0) {
                    
                    Image(user.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40.0)

                    Text(user.name)
                    Spacer()
                    Text(user.id)
                        .font(.caption2)
                }
            }
            Form {
                TextField("Email", text: $id)
                TextField("Name", text: $name)
                
                Picker("Image", selection: $image) {
                    ForEach(userImages, id: \.self) {
                        Text($0)
                    }
                }
                Button("Add user") {
                    dm.addUser(id: id, name: name, image: image)
                }
                .buttonStyle(.bordered)
            }
            .navigationTitle("Users")
        }
    }
}
struct Users_Previews: PreviewProvider {
    static var previews: some View {
        Users()
            .environmentObject(DataManager())
    }
}
