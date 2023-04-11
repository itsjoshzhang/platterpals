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
                return user
            }}
        return my()
    }

    // returns UserData
    func data(id: String) -> UserData {
        for data in userData {
            if data.id == id {
                return data
            }}
        return md()
    }

    private func initInfo() {
        // removeAll means no duplicates
        userList.removeAll()
        userData.removeAll()
        
        // 1. access firebase collection
        // 2. loop through all documents
        // 3. access values = map {data}
        // 4. create object using values
        // 5. append object to each list
        
        FS.collection("userList").getDocuments { col,_ in
            for doc in col!.documents {
                let data = doc.data()
                
                let id    = data["id"]    as? String ?? ""
                let name  = data["name"]  as? String ?? ""
                let text  = data["text"]  as? String ?? ""
                let city  = data["city"]  as? String ?? ""
                let views = data["views"] as? Int    ?? 1
                
                let user = User(id: id, name: name, text: text,
                                city: city, views: views)
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
        let user = User(id: id, name: name, text: "", city: city, views: 1)
        editUser(user: user)

        // create new data
        let data = UserData(id: id, favFoods: [String](), favUsers:
            [String](), chatting: [String](), blocked: [String]())
        editData(id: data.id, ff: data.favFoods, fu: data.favUsers,
                 ch: data.chatting, bl: data.blocked)

        // create new sets
        let sets = Setting(id: id, notifs: true, emails: true, privacy:
                            true, location: true)
        editSets(s: sets)
    }
    
    // called at Profile
    func editUser(user: User, views: Int = 0) {
        let doc = FS.collection("userList").document(user.id)

        doc.setData(["id": user.id, "name": user.name, "text": user.text,
                     "city": user.city, "views": user.views + views])
        if views == 0 {
            userList[thisUser] = user
        }
    }
    
    // called everywhere
    func editData(id: String, ff: [String], fu: [String], ch: [String],
                  bl: [String]) {
        let doc = FS.collection("userData").document(id)
        
        doc.setData(["id": id, "favFoods": ff, "favUsers": fu, "chatting":
                    ch, "blocked": bl])
        userData[thisUser] = UserData(id: id, favFoods: ff, favUsers: fu, chatting: ch, blocked: bl)
    }
    
    // called at Settings
    func editSets(s: Setting) {
        let doc = FS.collection("settings").document(s.id)
        
        doc.setData(["id": s.id, "notifs": s.notifs, "emails": s.emails,
                     "privacy": s.privacy, "location": s.location])
        settings = s
    }

    // called at Convo
    func sendChat(text: String, sender: String, getter: String, time: Date) {
        let id = UUID().uuidString
        let doc = FS.collection("messages").document(id)
        
        doc.setData(["id": id, "text": text, "sender": sender, "getter":
                    getter, "time": time])
    }
    
    // called at Order
    func sendOrder(order: String, place: String, rating: Int, time: Date) {
        let id = UUID().uuidString
        let doc = FS.collection("aiOrders").document(id)
        
        doc.setData(["id": id, "order": order, "place": place, "rating":
                    rating, "time": time])
    }

    // ## IMAGE LOGIC ## \\

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
    
    // 1. create object result array
    // 2. access firebase collection
    // 3. loop through all documents
    // 4. access values = map {data}
    // 5. if condition, add to array

    // called at Order
    func getOrder(id: String) -> [AIOrder] {
        var aiOrders = [AIOrder]()
        
        FS.collection("aiOrders").getDocuments { col,_ in
            for doc in col!.documents {
                let data = doc.data()
                    let docID  = data["id"]     as? String ?? ""
                
                if docID == id {
                    let order  = data["order"]  as? String ?? ""
                    let place  = data["place"]  as? String ?? ""
                    let rating = data["rating"] as? Int    ?? 0
                    let time   = data["time"]   as? Date   ?? Date()
                    
                    aiOrders.append(AIOrder(id: id, order: order, place:
                                    place, rating: rating, time: time))
                    return }}}
        return aiOrders
    }

    // called at init
    func getSetts() {
        FS.collection("settings").getDocuments { col,_ in
            for doc in col!.documents {
                
                let data = doc.data()
                let docID = data["id"] as? String ?? ""
                if docID == self.my().id {

                    let notifs   = data["notifs"]   as? Bool ?? true
                    let emails   = data["emails"]   as? Bool ?? true
                    let privacy  = data["privacy"]  as? Bool ?? true
                    let location = data["location"] as? Bool ?? true
                    
            self.settings = Setting(id: docID, notifs: notifs, emails:
                            emails, privacy: privacy, location: location)
            return
    }}}}}
