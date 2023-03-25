import SwiftUI
import Firebase
import FirebaseStorage

class DataManager: ObservableObject {

    // create FB database & storage
    private let FS = Firestore.firestore()
    private let SR = Storage.storage().reference()

    // track this user and its data
    private var thisUser: Int
    @Published var userList = [User]()
    @Published var userData = [UserData]()
    @Published var settings = Setting()

    init() { initInfo() }

    // returns a User
    func my() -> User {
        return userList[thisUser]
    }

    // returns UserData
    func data(id: String) -> UserData? {
        for data in userData {

            if (data.id == id) {
                return data
            }
        }
        return nil
    }

    // returns a User
    func user(id: String) -> User? {
        for user in userList {


            if (user.id == id || user.name == id) {
                return user
            }
        }
        return nil
    }

    // called at Upload
    func putImage(image: UIImage, path: String) -> Bool {

        // compute if image is an avatar
        var pfp = (path == "avatars")
        var done = false

        // get storage path with user id
        let SR = SR.child("\(path)/\(my().id).jpg")

        // resize & convert image to jpg
        let image = image.resize(width: 200, pfp: pfp)
        let jpeg = image.jpegData(compressionQuality: 0.25)

        // compute metadata for jpg type
        let meta = StorageMetadata()
        meta.contentType = "image/jpg"

        if let jpeg = jpeg {
            // put image into storage as jpg
            SR.putData(jpeg, metadata: meta) {_, error in
                if error == nil {

            // track success and return bool
            done = true }}}
        return done
    }

    // called everywhere
    func getImage(id: String, path: String) -> UIImage {

        // get storage path with user id
        let SR = SR.child("\(path)/\(id).jpg")
        var image: UIImage

        // get image data (max size 8MB)
        SR.getData(maxSize: 8 * 1024 * 1024) { data, error in
            if let data = data {

        // ASYNC: return image from data
        DispatchQueue.main.async {
            image = UIImage(data: data) ??

            // if nil return logo as default
            UIImage(named: "logo.png")! }}}
        return image
    }

    // TODO: call getImage() inside onAppear() in views and append return value to local @State lists of [UIImage]

    func initInfo() {
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
                
                let id       = data["id"]       as? String ?? ""
                let favFoods = data["favFoods"] as? [String] ?? d
                let favUsers = data["favUsers"] as? [String] ?? d
                let chatting = data["chatting"] as? [String] ?? d
                let blocked  = data["blocked"]  as? [String] ?? d
                
                let userData = UserData(id: id, favFoods: favFoods,
                    favUsers: favUsers, chatting: chatting, blocked: blocked)
                self.userData.append(userData)
            }
        }
        // sort allows index w/ thisUser
        userList.sort { $0.id < $1.id }
        userData.sort { $0.id < $1.id }
    }

    // called at Login
    func initUser(id: String) {

        // traverse userList to check id
        for index in 0 ..< userList.count {
            if userList[index].id == id {

        // if IDs match, assign thisUser
                thisUser = index
                getSetts()
                return
            }
        }
    }
    
    // called at Signup
    func makeUser(id: String, name: String, city: String) {
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
        let image = "avatars/\(id)"
        
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
    func sendOrder(order: String, location: String, rating: Int, time: Date) {
        let id = UUID().uuidString
        let AIOrder = FS.collection("aiOrders").document(id)
        
        AIOrder.setData(["id": id, "order": order, "location": location,
                         "rating": rating, "time": time])
    }
    
    // 1. create object result array
    // 2. access firebase collection
    // 3. loop through all documents
    // 4. access values = map {data}
    // 5. if condition, add to array

    @Published var messages = [Message]()

    // TODO: fix this shit fix this shit fix this shit fix this shit fix this shit fix this shit fix this shit fix this shit fix this shit fix this shit fix this shit fix this shit fix this shit fix this shit fix this shit fix this shit fix this shit fix this shit fix this shit fix this shit fix this shit fix this shit fix this shit fix this shit fix this shit
    // called at Chats
    func getChats(senderID: String, getterID: String) {
        FS.collection("messages").addSnapshotListener { collection, error in
            
            for document in collection!.documents {
                let data = document.data()
                
                let id     = data["id"]     as! String
                let text   = data["text"]   as! String
                let sender = data["sender"] as! String
                let getter = data["getter"] as! String
                let time   = data["time"]   as? Date ?? Date()

                if (sender == senderID && getter == getterID) {
                    
                    self.messages.append(Message(id: id, text: text, sender: sender,
                                                 getter: getter, time: time))
                    self.messages.sort {
                        $0.time < $1.time
                    }}}}}


    // called at Order
    func getOrder(id: String) -> [AIOrder] {
        var aiOrders = [AIOrder]()
        
        FS.collection("aiOrders").getDocuments { collection, error in
            for document in collection!.documents {
                
                let data = document.data()
                let docID = data["id"] as! String
                
                if docID == id {
                    let order  = data["order"]  as? String ?? ""
                    let place  = data["place"]  as? String ?? ""
                    let rating = data["rating"] as? Int ?? 0
                    let time   = data["time"]   as? Date ?? Date()
                    
                    aiOrders.append(AIOrder(id: id, order: order, place:
                                    place, rating: rating, time: time))
                }
            }
        }
        return aiOrders
    }

    // called at init
    func getSetts() {
        FS.collection("settings").getDocuments { collection, error in
            for document in collection!.documents {
                
                let data = document.data()
                let id = data["id"] as! String
                
                if self.my().id == id {
                    
                    let notifs   = data["notifs"]   as! Bool
                    let emails   = data["emails"]   as! Bool
                    let privacy  = data["privacy"]  as! Bool
                    let location = data["location"] as! Bool
                    
                    self.settings = Setting(id: id, notifs: notifs, emails:
                                    emails, privacy: privacy, location: location)
                    return
                }
            }
        }
    }
}
