/* TODO: fix TODOs

initUser(id: String) -> changes {DM}
    -* thisUser
 
user() || data() || prof() -> nil
    -> User || UserData || Profile

initVars() -> changes {DM}
    -* userList && userData && profiles

makeUser() -> changes {FS}
    -* userList && userData && profiles && settings

edit....() -> changes {FS}
    -* whatever {....} is
    -* userList || userData || profiles || settings

getChats(id: String) -> [Message]

getOrder(id: String) -> [AIOrder]

getSetts() -> changes {DM}
    -* settings
*/

import SwiftUI
import Firebase

// DataManager stores all firestore info
class DataManager: ObservableObject {
    
    // instance vars (storage & tracker)
    let FS = Firestore.firestore()
    @Published var thisUser = 0
    
    // instance vars (list of user info)
    @Published var userList = [User]()
    @Published var userData = [UserData]()
    @Published var profiles = [Profile]()
    @Published var settings = Setting()
    
    // list of cities in menu @ {Signup}
    var location = ["Berkeley", "Fremont", "Irvine", "Los Angeles", "Oakland",
        "Palo Alto", "Pleasanton", "Riverside", "San Francisco", "San Jose"]
    
    // initUser is called ONCE @ {Login}
    func initUser(id: String) {
        
        // loop through list to check id
        for index in 0...userList.count {
            if userList[index].id == id {
                thisUser = index
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
        // 3. access values in map {data}
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
    func makeUser(id: String, name: String, image: String, city: String) {
        
        // 1. access firebase collection
        // 2. make new document with {id}
        // 3. setData to document values
        // 4. set instance var = new obj
        editUser(id: id, name: name, image: image, city: city)
        editData(id: id, fa: [String](), fo: [String](), ch: [String](), bl: [String]())
        editProf(id: id, name: name, image: "", text: "", likes: 0)
        editSets(id: id, no: true, em: true, pr: true, lo: true)
    }
    
    // editUser is called by @{SelfProf}
    func editUser(id: String, name: String, image: String, city: String) {
        let user = FS.collection("userList").document(id)
        
        user.setData(["id": id, "name": name, "image": image, "city": city])
        userList[thisUser] = User(id: id, name: name, image: image, city: city)
    }
    
    // editData is called by @{SelfProf}
    func editData(id: String, fa: [String], fo: [String], ch: [String], bl: [String]) {
        let data = FS.collection("userData").document(id)
        
        data.setData(["id": id, "favorites": fa, "following": fo, "chatting": ch, "blocked": bl])
        userData[thisUser] = UserData(id: id, favorites: fa, following: fo, chatting: ch, blocked: bl)
    }
    
    // editProf is called by @{SelfProf}
    func editProf(id: String, name: String, image: String, text: String, likes: Int) {
        let profile = FS.collection("profiles").document(id)
        
        profile.setData(["id": id, "name": name, "image": image, "text": text, "likes": likes])
        profiles[thisUser] = Profile(id: id, name: name, image: image, text: text, likes: likes)
    }
    
    // editSets is called by @{Settings}
    func editSets(id: String, no: Bool, em: Bool, pr: Bool, lo: Bool) {
        let setting = FS.collection("settings").document(id)
        
        setting.setData(["id": id, "notifs": no, "emails": em, "privacy": pr, "location": lo])
        settings = Setting(id: id, notifs: no, emails: em, privacy: pr, location: lo)
    }
    
    // getChats is called by {Chats} page
    func getChats(id: String) -> [Message] {
        var messages = [Message]()
        
        FS.collection("settings").getDocuments { collection, error in
            
            for document in collection!.documents {
                let data = document.data()
                let docID = data["id"] as! String
                
                if docID == id {
                    let text   = data["text"]   as! String
                    let sender = data["sender"] as! String
                    let getter = data["getter"] as! String
                    let time   = data["time"]   as! Date
                    
                    messages.append(Message(id: id, text: text, sender: sender,
                                            getter: getter, time: time))
                }
            }
        }
        return messages
    }
    
    // getOrder is called by Order pages
    func getOrder(id: String) -> [AIOrder] {
        var orderLst = [AIOrder]()
        
        FS.collection("settings").getDocuments { collection, error in
            
            for document in collection!.documents {
                let data = document.data()
                let docID = data["id"] as! String
                
                if docID == id {
                    let order    = data["order"]    as! String
                    let location = data["location"] as! String
                    let rating   = data["rating"]   as! Int
                    let time     = data["time"]     as! Date
                    
                    orderLst.append(AIOrder(id: id, order: order, location:
                                    location, rating: rating, time: time))
                }
            }
        }
        return orderLst
    }
    
    // getSetts is called by @{Settings}
    func getSetts() {
        FS.collection("settings").getDocuments { collection, error in
            
            for document in collection!.documents {
                let data = document.data()
                let docID = data["id"] as! String
                
                if self.user().id == docID {
                    
                    let notifs   = data["notifs"]   as! Bool
                    let emails   = data["emails"]   as! Bool
                    let privacy  = data["privacy"]  as! Bool
                    let location = data["location"] as! Bool
                    
                    self.settings = Setting(id: docID, notifs: notifs, emails:
                                    emails, privacy: privacy, location: location)
                    return
    }}}}}
