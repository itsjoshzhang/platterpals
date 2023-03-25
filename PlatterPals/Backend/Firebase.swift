import SwiftUI
import Firebase
import FirebaseStorage

class DataManager: ObservableObject {

    private let FS = Firestore.firestore()
    private let SR = Storage.storage().reference()

    private var thisUser = 0
    @Published var userList = [User]()
    @Published var userData = [UserData]()
    @Published var settings = Setting()

    func putImage(image: UIImage, path: String) -> Bool {
        var done = false

        var pfp = (path == "avatars")
        let path = SR.child("\(path)/\(user().id).jpg")

        let image = image.resize(width: 200, pfp: pfp)
        let jpeg = image.jpegData(compressionQuality: 0.25)

        let meta = StorageMetadata()
        meta.contentType = "image/jpg"

        if let jpeg = jpeg {
            path.putData(jpeg, metadata: meta) {_, error in
                if error == nil {
                    done = true
                }}}
        return done
    }

    func listAll(path: String) {
        let path = SR.child(path)

        path.listAll { result, error in
            if error != nil {
                for item in result!.items {
                    print(item)
    }}}}

    func delImage(item: StorageReference) {
        item.delete { error in }
    }

    // getImage is called by Home / Prof
    func getImage(id: String, path: String, state: UIImage) {

        // access FS storage at path, id
        var image = UIImage(named: "logo")
        let SR = Storage.storage().reference().child("\(path)/\(id)")

        // get data and make new UIImage
        SR.getData(maxSize: 16 * 1024 * 1024) { data, error in
            if let data = data, let uiImage = UIImage(data: data) {

            }
        }
        DispatchQueue.main.async {
            return image!
        }
    }

    func initUser(id: String) {
        
        // loop through list to check id
        for index in 0 ..< userList.count {
            if userList[index].id == id {
                
        // reassign thisUser if ID match
                thisUser = index
                getSetts()
                break
            }
        }
    }
    
    // help is called by all views/files
    func user() -> User {
        return userList[thisUser]
    }

    func data() -> UserData {
        return userData[thisUser]
    }

    func prof(id: String) -> Profile {
        for prof in profiles {
            if prof.id == id {
                return prof
            }
        }
        return Profile(id: "", image: "", city: "", text: "", likes: 0)
    }

    func find(id: String) -> User {
        for user in userList {
            if (user.id == id || user.name == id) {
                return user
            }
        }
        return user()
    }

    func initLoad() {
        // clear all lists no duplicates
        userList.removeAll()
        userData.removeAll()
        profiles.removeAll()
        
        // 1. access firebase collection
        // 2. loop through all documents
        // 3. access values = map {data}
        // 4. create object using values
        // 5. append object to each list
        
        FS.collection("userList").getDocuments { collection, error in
            
            for document in collection!.documents {
                let data = document.data()
                
                let id    = data["id"]    as! String
                let name  = data["name"]  as! String
                let image = data["image"] as! String
                let city  = data["city"]  as! String
                
                let user = User(id: id, name: name, image: image, city: city)
                self.userList.append(user)
            }
        }
        
        FS.collection("userData").getDocuments { collection, error in
            
            for document in collection!.documents {
                let data = document.data()
                
                let id        = data["id"]        as! String
                let favorites = data["favorites"] as! [String]
                let following = data["following"] as! [String]
                let chatting  = data["chatting"]  as! [String]
                let blocked   = data["blocked"]   as! [String]
                
                let userData = UserData(id: id, favorites: favorites, following:
                               following, chatting: chatting, blocked: blocked)
                self.userData.append(userData)
            }
        }
        
        FS.collection("profiles").getDocuments { collection, error in
            
            for document in collection!.documents {
                let data = document.data()
                
                let id    = data["id"]    as! String
                let image = data["image"] as! String
                let city = data["city"]   as! String
                let text  = data["text"]  as! String
                let likes = data["likes"] as! Int
                
                let profile = Profile(id: id, image: image, city: city,
                                      text: text, likes: likes)
                self.profiles.append(profile)
            }
        }
        
        // sort all, index with thisUser
        userList.sort { $0.id < $1.id }
        userData.sort { $0.id < $1.id }
        profiles.sort { $0.id < $1.id }
    }
    
    // makeUser is called ONCE @{Signup}
    func makeUser(id: String, name: String, city: String) {
        let id = id.replacingOccurrences(of: ".", with: "_")

        editUser(id: id, name: name, city: city)
        editData(id: id, fa: [String](), fo: [String](), ch: [String](),
                 bl: [String]())

        editProf(id: id, city: city, text: "Add a bio", likes: 0)
        editSets(id: id, no: true, em: true, pr: true, lo: true)
        initUser(id: id)
    }
    
    // 1. makeUser chooses edit func
    // 2. access firebase collection
    // 3. create document using {id}
    // 4. setData to document values
    // 5. set instance var = new obj
    
    // editUser is called @{Profile} page
    func editUser(id: String, name: String, city: String) {
        let image = "avatars/\(id)"
        
        let user = FS.collection("userList").document(id)
        user.setData(["id": id, "name": name, "image": image, "city": city])
        
        userList.append(User(id: id, name: name, image: image, city: city))
    }
    
    // editData is called @{Profile} page
    func editData(id: String, fa: [String], fo: [String], ch: [String], bl: [String]) {
        let data = FS.collection("userData").document(id)
        
        data.setData(["id": id, "favorites": fa, "following": fo, "chatting": ch,
                      "blocked": bl])
        userData.append(UserData(id: id, favorites: fa, following: fo, chatting:
                                 ch, blocked: bl))
    }
    
    // editProf is called @{Profile} page
    func editProf(id: String, city: String, text: String, likes: Int) {
        let image = "profiles/\(id)"

        let profile = FS.collection("profiles").document(id)
        
        profile.setData(["id": id, "image": image, "city": city, "text": text,
                         "likes": likes])
        profiles.append(Profile(id: id, image: image, city: city, text: text,
                                likes: likes))
    }
    
    // editSets is called by @{Settings}
    func editSets(id: String, no: Bool, em: Bool, pr: Bool, lo: Bool) {
        let setting = FS.collection("settings").document(id)
        
        setting.setData(["id": id, "notifs": no, "emails": em, "privacy": pr,
                         "location": lo])
        settings = Setting(id: id, notifs: no, emails: em, privacy: pr,
                           location: lo)
    }
    
    // sendChat is called @ {Convo} page
    func sendChat(text: String, sender: String, getter: String, time: Date) {
        
        let id = UUID().uuidString
        let message = FS.collection("messages").document(id)
        
        message.setData(["id": id, "text": text, "sender": sender, "getter":
                         getter, "time": time])
    }
    
    // sendOrder is called by @ {Order}
    func sendOrder(order: String, location: String, rating: Int, time: Date) {
        let id = UUID().uuidString
        let AIOrder = FS.collection("aiOrders").document(id)
        
        AIOrder.setData(["id": id, "order": order, "location": location,
                         "rating": rating, "time": time])
    }
    
    // 1. create object return array
    // 2. access firebase collection
    // 3. loop through all documents
    // 4. access values = map {data}
    // 5. if condition, add to array

    @Published var messages = [Message]()

    // getChats is called by {Chats} page
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


    // getOrder is called by Order pages
    func getOrder(id: String) -> [AIOrder] {
        var aiOrders = [AIOrder]()
        
        FS.collection("aiOrders").getDocuments { collection, error in
            for document in collection!.documents {
                
                let data = document.data()
                let docID = data["id"] as! String
                
                if docID == id {
                    let order    = data["order"]    as! String
                    let location = data["location"] as! String
                    let rating   = data["rating"]   as! Int
                    let time     = data["time"]     as! Date
                    
                    aiOrders.append(AIOrder(id: id, order: order, location:
                                    location, rating: rating, time: time))
                }
            }
        }
        return aiOrders
    }

    // getSetts is called ONCE at {init}
    func getSetts() {
        
        FS.collection("settings").getDocuments { collection, error in
            for document in collection!.documents {
                
                let data = document.data()
                let id = data["id"] as! String
                
                if self.user().id == id {
                    
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
