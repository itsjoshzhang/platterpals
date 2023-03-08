/* File: checked
 
initUser(id: String) -> changes {DM}
    -* thisUser
 
user() || data() || prof() ->
    -> User || UserData || Profile

initVars() -> changes {DM}
    -* userList && userData && profiles

makeUser() -> changes {FS}
    -> call to edit....()

edit....() -> changes {FS}
    -* whatever {....} is
    -* userList || userData || profiles || settings

getChats(id: String) -> [Message]

getOrder(id: String) -> [AIOrder]

getSetts() -> changes {DM}
    -* settings
 
putImage(id, path, image) -> changes {FS}
    -* profiles/ || avatars/
 
getImage(id, path) -> UIImage
*/

import SwiftUI
import Firebase
import FirebaseStorage

// DataManager stores all Firestore info
class DataManager: ObservableObject {
    
    // instance vars (storage & tracker)
    let FS = Firestore.firestore()
    @Published var thisUser = 0
    
    // instance vars (keeping user info)
    @Published var userList = [User]()
    @Published var userData = [UserData]()
    @Published var profiles = [Profile]()
    @Published var settings = Setting()
    @Published var loggedIn = false;
    
    // list of cities in menu @ {Signup}
    var cityList = ["Berkeley", "Fremont", "Irvine", "Los Angeles", "Oakland",
        "Palo Alto", "Pleasanton", "Riverside", "San Francisco", "San Jose"]
    
    // list of foods in menu @ {Suggest}
    var foodList = ["All", "American", "Brazilian", "Caribbean", "Chinese",
                    "Ethiopian", "French", "Indian", "Italian", "Japanese",
                    "Korean", "Mexican", "Middle Eastern", "Thai", "Vietnamese"]
    
    // func called ONCE @ {Login/Signup}
    func initUser(id: String) {
        
        // loop through list to check id
        for index in 0 ..< userList.count {
            if userList[index].id == id {
                
        // reassign thisUser if ID match
                thisUser = index
                loggedIn = true
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
    func prof() -> Profile {
        return profiles[thisUser]
    }
    
    init() {
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
                let name  = data["name"]  as! String
                let image = data["image"] as! String
                let text  = data["text"]  as! String
                let likes = data["likes"] as! Int
                
                let profile = Profile(id: id, name: name, image: image,
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
        
        let user = "avatars/\(id)"
        let prof = "profiles/\(id)"
        
        editUser(id: id, name: name, image: user, city: city)
        editData(id: id, fa: [String](), fo: [String](), ch: [String](),
                 bl: [String]())
        
        editProf(id: id, name: name, image: prof, text: "Add a bio", likes: 0)
        editSets(id: id, no: true, em: true, pr: true, lo: true)
        initUser(id: id)
    }
    
    // 1. makeUser chooses edit func
    // 2. access firebase collection
    // 3. create document using {id}
    // 4. setData to document values
    // 5. set instance var = new obj
    
    // editUser is called @{Myself} page
    func editUser(id: String, name: String, image: String, city: String) {
        
        let user = FS.collection("userList").document(id)
        user.setData(["id": id, "name": name, "image": image, "city": city])
        
        userList.append(User(id: id, name: name, image: image, city: city))
    }
    
    // editData is called @{Myself} page
    func editData(id: String, fa: [String], fo: [String], ch: [String], bl: [String]) {
        let data = FS.collection("userData").document(id)
        
        data.setData(["id": id, "favorites": fa, "following": fo, "chatting": ch,
                      "blocked": bl])
        userData.append(UserData(id: id, favorites: fa, following: fo, chatting:
                                 ch, blocked: bl))
    }
    
    // editProf is called @{Myself} page
    func editProf(id: String, name: String, image: String, text: String, likes: Int) {
        let profile = FS.collection("profiles").document(id)
        
        profile.setData(["id": id, "name": name, "image": image, "text": text,
                         "likes": likes])
        profiles.append(Profile(id: id, name: name, image: image, text: text,
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
    
    // getChats is called by {Chats} page
    func getChats(senderID: String, getterID: String) -> [Message] {
        
        var messages = [Message]()
        FS.collection("messages").getDocuments { collection, error in
            
            for document in collection!.documents {
                let data = document.data()
                
                let id     = data["id"]     as! String
                let text   = data["text"]   as! String
                let sender = data["sender"] as! String
                let getter = data["getter"] as! String
                let time   = data["time"]   as! Date
                    
                if (sender == senderID) && (getter == getterID) {
                    
                    messages.append(Message(id: id, text: text, sender: sender,
                                    getter: getter, time: time))
                }
            }
        }
        return messages
    }
    
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
    
    // putImage is called by Upload page
    func putImage(id: String, path: String, image: Data?) {
        
        // access FS storage at path, id
        let SR = Storage.storage().reference().child("\(path)/\(id)")
        SR.putData(image!, metadata: nil)
    }
    
    // getImage is called by Home / Prof
    func getImage(id: String, path: String) -> UIImage {
        
        // access FS storage at path, id
        var image = UIImage()
        let SR = Storage.storage().reference().child("\(path)/\(id)")
        
        // get data and make new UIImage
        SR.getData(maxSize: 16 * 1024 * 1024) { data, error in
            image = UIImage(data: data!)!
        }
        return image
    }
}
