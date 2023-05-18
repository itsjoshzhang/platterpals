import SwiftUI
import Firebase
import FirebaseStorage

// create FB database & storage
let FS = Firestore.firestore()
let SR = Storage.storage().reference()

class DataManager: ObservableObject {

    // track user id and their data
    @Published var userList = [User]()
    @Published var userData = [UserData]()
    @Published var settings = Setting()

    @Published var thisUser = 0
    @Published var myAvatar: UIImage?
    @Published var myProfile: UIImage?

    init() { initInfo() }

    // returns myself
    func my() -> User {
        return userList[thisUser]
    }

    // return my data
    func md() -> UserData {
        return userData[thisUser]
    }

    // returns a User
    func user(id: String) -> User {
        for user in userList {
            if (user.id == id || user.name == id) {
                return user }}
        return my()
    }

    // returns UserData
    func data(id: String) -> UserData {
        for data in userData {
            if data.id == id {
                return data }}
        return md()
    }

    private func initInfo() {
        // removeAll means no duplicates
        userList.removeAll()
        userData.removeAll()
        
        FS.collection("userList").getDocuments { col,_ in
            for doc in col!.documents {
                let data = doc.data()
                
                let id    = data["id"]    as? String ?? ""
                let name  = data["name"]  as? String ?? ""
                let text  = data["text"]  as? String ?? ""
                let city  = data["city"]  as? String ?? ""
                
                let user = User(id: id, name: name, text: text,
                                city: city)
                self.userList.append(user)
            }
        }
        FS.collection("userData").getDocuments { col,_ in
            for doc in col!.documents {
                let data = doc.data()
                let d = [String]()
                
                let id       = data["id"]       as? String   ?? ""
                let favFoods = data["favFoods"] as? [String] ?? d
                let favUsers = data["favUsers"] as? [String] ?? d
                let chatting = data["chatting"] as? [String] ?? d
                let blocked  = data["blocked"]  as? [String] ?? d
                
                let userData = UserData(id: id, favFoods: favFoods,
            favUsers: favUsers, chatting: chatting, blocked: blocked)
                self.userData.append(userData)
            }
        }
    }

    // called at Login
    func initUser(id: String) {
        let id = id.replacingOccurrences(of: ".", with: "_")

        // traverse userList to check id
        for i in (0 ..< userList.count) {

            // if IDs match, assign thisUser
            if userList[i].id == id {
                thisUser = i
                break
            }
        }
        // download images and settings
        getImage(path: "avatars")
        getImage(path: "profiles")
        getSetts()
    }
    
    // called at Signup
    func makeUser(id: String, name: String, city: String) {
        let id = id.replacingOccurrences(of: ".", with: "_")

        // create new user
        let user = User(id: id, name: name, text: "", city: city)
        editUser(user: user)

        // create new data
        let data = UserData(id: id, favFoods: [String](), favUsers:
            [String](), chatting: [String](), blocked: [String]())
        editData(data: data)

        // create new sets
        let sets = Setting(id: id, notifs: true, suggest: true,
                           privacy: true, location: true)
        editSets(sets: sets)
    }
    
    // called at Profile
    func editUser(user: User) {
        let doc = FS.collection("userList").document(user.id)

        doc.setData(["id": user.id, "name": user.name, "text":
            user.text, "city": user.city])
    }
    
    // called everywhere
    func editData(data: UserData) {
        let doc = FS.collection("userData").document(data.id)
        
        doc.setData(["id": data.id, "favFoods": data.favFoods, "favUsers":
            data.favUsers, "chatting": data.chatting, "blocked": data.blocked])
        userData[thisUser] = data
    }
    
    // called at Settings
    func editSets(sets: Setting) {
        let doc = FS.collection("settings").document(sets.id)
        
        doc.setData(["id": sets.id, "notifs": sets.notifs, "suggest":
            sets.suggest, "privacy": sets.privacy, "location": sets.location])
        settings = sets
    }

    // called at Convo
    func sendChat(text: String, sender: String, getter: String, time: Date) {
        let id = UUID().uuidString
        let doc = FS.collection("messages").document(id)
        
        doc.setData(["id": id, "text": text, "sender": sender,
                     "getter": getter, "time": time])
    }
    
    // called at Order
    func sendOrder(emoji: String, user: String, order: String, place:
                   String, rating: Int, time: Date) {
        let id = UUID().uuidString
        let doc = FS.collection("aiOrders").document(id)
        
        doc.setData(["id": emoji + id, "user": user, "order": order,
                     "place": place, "rating": rating, "time": time])
    }

    // called at Upload
    func putImage(image: UIImage, path: String) {

        // get storage path with user id
        let SR = SR.child("\(path)/\(my().id).jpg")
        let pfp = (path == "avatars")

        // resize & convert image to jpg
        let image = image.resize(width: 200, pfp: pfp)
        let jpeg = image.jpegData(compressionQuality: 1)

        // compute metadata for jpg type
        let meta = StorageMetadata()
        meta.contentType = "image/jpg"

        // put image into storage as jpg
        if let jpeg = jpeg {
            SR.putData(jpeg, metadata: meta)
        }
    }

    // called at init
    func getImage(path: String) {
        let SR = SR.child("\(path)/\(my().id).jpg")

        SR.getData(maxSize: 8 * 1024 * 1024) { data,_ in
            if let data = data {

                DispatchQueue.main.async {
                    if path == "avatars" {
                        self.myAvatar = UIImage(data: data)
                    } else {
                        self.myProfile = UIImage(data: data)
                    }}}}}

    // called at Update
    func delImage(path: String) {
        let SR = SR.child("\(path)/\(my().id).jpg")
        SR.delete { _ in }
    }

    // called at init
    func getSetts() {
        FS.collection("settings").getDocuments { col,_ in
            for doc in col!.documents {
                
                let data = doc.data()
                    let docID = data["id"] as? String ?? ""
                if docID == self.my().id {

                    let notifs   = data["notifs"]   as? Bool ?? true
                    let suggest  = data["suggest"]  as? Bool ?? true
                    let privacy  = data["privacy"]  as? Bool ?? true
                    let location = data["location"] as? Bool ?? true
                    
            self.settings = Setting(id: docID, notifs: notifs,
            suggest: suggest, privacy: privacy, location: location)
            return
    }}}}

    // called on profiles
    func findHearts(id: String) -> Int {
        var hearts = 0
        for data in userData {
            if data.favUsers.contains(id) {
                hearts += 1
            }
        }
        return hearts
    }
}
