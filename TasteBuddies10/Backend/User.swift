import SwiftUI
import Firebase

struct User: Identifiable, Codable {
    var id: String
    var name: String
}


class DataManager: ObservableObject {
    @Published var users: [User] = []
    
    init() {
        fetchUsers()
    }
    func fetchUsers() {
        users.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Users")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    
                    let user = User(id: id, name: name)
                    self.users.append(user)
                }
            }
        }
    }
    func addUser(name: String) {
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(name)
        ref.setData(["name": name, "id": 0]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }// dataManager.addUser(name: "New user")
    }// id of 10 is usually a randomly generated int
}
struct ListView: View {
    
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationStack {
            List(dataManager.users) { user in
                Text(user.name)
            }
            .navigationTitle("Users")
        }
    }
}
struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environmentObject(DataManager())
    }
}
