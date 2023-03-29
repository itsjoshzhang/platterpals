import SwiftUI
import Firebase
import FirebaseStorage

// create FB database & storage
let FS = Firestore.firestore()
let SR = Storage.storage().reference()

class DataManager: ObservableObject {

    // track user id and their data
    @Published var thisUser = 0
    @Published var userList = [User]()
    @Published var userData = [UserData]()
    @Published var settings = Setting()

    init() { initInfo() }

    // returns myself
    func my() -> User {
        return userList[thisUser]
    }

    // returns a User
    func user(id: String) -> User {
        for user in userList {

            if (user.id == id || user.name == id) {
                return user
            }}
        return User(id: "", name: "", text: "", city: "", views: 0)
    }

    // returns UserData
    func data(id: String) -> UserData {
        for data in userData {

            if (data.id == id) {
                return data
            }}
        return userData[thisUser]
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

    // called at Update
    func delImage(path: String) {
        let SR = SR.child("\(path)/\(my().id).jpg")
        SR.delete { _ in }
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
        
        FS.collection("userList").getDocuments { col, error in
            for doc in col!.documents {
                let data = doc.data()
                
                let id    = data["id"]    as? String ?? ""
                let name  = data["name"]  as? String ?? ""
                let text  = data["text"]  as? String ?? ""
                let city  = data["city"]  as? String ?? ""
                let views = data["views"] as? Int    ?? 0
                
                let user = User(id: id, name: name, text: text,
                                city: city, views: views)
                self.userList.append(user)
            }
        }
        FS.collection("userData").getDocuments { col, error in
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

        // traverse userList to check id
        for index in 0 ..< userList.count {
            if userList[index].id == id {

                // if IDs match, assign thisUser
                thisUser = index
                getSetts()
                break
            }
        }
    }
    
    // called at Signup
    func makeUser(id: String, name: String, city: String) {

        // replacing avoids image errors
        let id = id.replacingOccurrences(of: ".", with: "_")

        editUser(id: id, name: name, text: "", city: city, views: 0)
        editData(id: id, fo: [String](), us: [String](), ch: [String](), bl: [String]())
        editSets(id: id, notifs: true, emails: true, privacy: true, location: true)
        initUser(id: id)
    }
    
    // 1. makeUser chooses edit func
    // 2. access firebase collection
    // 3. create document using {id}
    // 4. setData to document values
    // 5. set instance var = new obj
    
    // called at Profile
    func editUser(id: String, name: String, text: String, city: String, views: Int) {
        let user = FS.collection("userList").document(id)

        user.setData(["id": id, "name": name, "text": text, "city": city, "views": views])
        userList.append(User(id: id, name: name, text: text, city: city, views: views))
    }
    
    // called at Profile
    func editData(id: String, fo: [String], us: [String], ch: [String], bl: [String]) {
        let data = FS.collection("userData").document(id)
        
        data.setData(["id": id, "favFoods": fo, "favUsers": us, "chatting": ch, "blocked": bl])
        userData.append(UserData(id: id, favFoods: fo, favUsers: us, chatting: ch, blocked: bl))
    }
    
    // called at Settings
    func editSets(id: String, notifs: Bool, emails: Bool, privacy: Bool, location: Bool) {
        let setting = FS.collection("settings").document(id)
        
        setting.setData(["id": id, "notifs": notifs, "emails": emails, "privacy": privacy,
                         "location": location])
        settings = Setting(id: id, notifs: notifs, emails: emails, privacy: privacy,
                           location: location)
    }
    
    // called at Convo
    func sendChat(text: String, sender: String, getter: String, time: Date) {
        let id = UUID().uuidString
        let message = FS.collection("messages").document(id)
        
        message.setData(["id": id, "text": text, "sender": sender, "getter":
                            getter, "time": time])
    }
    
    // called at Order
    func sendOrder(order: String, place: String, rating: Int, time: Date) {
        let id = UUID().uuidString
        let AIOrder = FS.collection("aiOrders").document(id)
        
        AIOrder.setData(["id": id, "order": order, "place": place, "rating":
                            rating, "time": time])
    }
    
    // 1. create object result array
    // 2. access firebase collection
    // 3. loop through all documents
    // 4. access values = map {data}
    // 5. if condition, add to array

    // called at Chats
    func getChats(senderID: String, getterID: String) -> [Message] {
        var messages = [Message]()

        FS.collection("messages").addSnapshotListener { col, error in
            for doc in col!.documents {
                let data = doc.data()
                
                let id     = data["id"]     as? String ?? ""
                let text   = data["text"]   as? String ?? ""
                let sender = data["sender"] as? String ?? ""
                let getter = data["getter"] as? String ?? ""
                let time   = data["time"]   as? Date   ?? Date()

                if (sender == senderID && getter == getterID) {
                    messages.append(Message(id: id, text: text, sender:
                                    sender, getter: getter, time: time))
                    messages.sort { $0.time < $1.time }
                    return }}}
        return messages
    }

    // called at Order
    func getOrder(id: String) -> [AIOrder] {
        var aiOrders = [AIOrder]()
        
        FS.collection("aiOrders").getDocuments { col, error in
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
        FS.collection("settings").getDocuments { col, error in
            for doc in col!.documents {
                
                let data = doc.data()
                    let docID    = data["id"]       as? String ?? ""
                
                if docID == self.my().id {
                    
                    let notifs   = data["notifs"]   as? Bool ?? true
                    let emails   = data["emails"]   as? Bool ?? true
                    let privacy  = data["privacy"]  as? Bool ?? true
                    let location = data["location"] as? Bool ?? true
                    
                    self.settings = Setting(id: docID, notifs: notifs, emails:
                                    emails, privacy: privacy, location: location)
                    return }}}}}
