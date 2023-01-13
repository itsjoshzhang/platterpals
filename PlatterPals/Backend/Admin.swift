import SwiftUI
import Firebase

struct User: Identifiable {
    var id = "email@gmail.com"
    var name = "PlatterPals"
    var bio = "About me:"
    var image = "logo"
}
class DataManager: ObservableObject {
    
    @Published var userArray: [User] = []
    @Published var user = User()
    init() {
        fetchUsers()
    }
    func fetchUsers(paramID: String = "") {
        
        userArray.removeAll()
        let db = Firestore.firestore()
        db.collection("users").getDocuments { snapshot, error in

            for document in snapshot!.documents {
                let data = document.data()
                
                let id = data["id"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let bio = data["bio"] as? String ?? ""
                let image = data["image"] as? String ?? ""
                
                let user = User(id: id, name: name, bio: bio, image: image)
                self.userArray.append(user)
                if paramID == id {
                    let fetch = self.fetchData(name: name, route: true)
                    self.setUser(id, name, bio, fetch)
                }
            }
        }
    }
    func addUser(_ id: String, _ name: String, _ bio: String, _ image: String) {
        let db = Firestore.firestore()
        let ref = db.collection("users").document(id)
        
        ref.setData(["id": id, "name": name, "bio": bio, "image": image])
        setUser(id, name, bio, image)
    }
    func setUser(_ id: String, _ name: String, _ bio: String, _ image: String) {
        self.user = User(id: id, name: name, bio: bio, image: image)
    }
    func fetchData(name: String, route: Bool) -> String {
        for i in 0..<userArray.count {
            let user = userArray[i]
            if name == user.name {
                if route {
                    return user.image
                } else {
                    return user.bio
                }
            }
        }
        return "logo"
    }
}
struct Admin: View {
    
    @State var id = ""
    @State var name = ""
    @State var image = "logo"
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dm: DataManager
    
    var body: some View {
        NavigationStack {
            List {
                Text("Current user")
                HStack(spacing: 16.0) {
                    
                    Image(dm.user.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40.0)
                    
                    Text(dm.user.name)
                    Spacer()
                    Text(dm.user.id)
                        .font(.caption2)
                }
                Text("All users")
                ForEach(dm.userArray) { user in
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
            }
            Form {
                Button("Add user") {
                    dm.addUser(id, name, "", image)
                }
                .buttonStyle(.bordered)
                TextField("Email", text: $id)
                TextField("Name", text: $name)
                
                Picker("Image", selection: $image) {
                    ForEach(userImages, id: \.self) {
                        Text($0)
                    }
                }
            }
            .navigationTitle("Admin")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("\(Image(systemName: "chevron.backward")) Back") {
                        dismiss()
                    }}}}}}


struct Admin_Previews: PreviewProvider {
    static var previews: some View {
        Admin()
            .environmentObject(DataManager())
    }
}
