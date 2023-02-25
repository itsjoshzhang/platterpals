// TODO: fix TODOs

import SwiftUI
import Firebase

// DataManager manages all firestore information
class DataManager: ObservableObject {
    
    // instance variables (lists of users' info)
    @Published var thisUser = 0
    @Published var userList = [User]()
    @Published var userData = [UserData]()
    @Published var profiles = [Profile]()
    @Published var settings = [Setting]()
    
    // list of cities in dropdown menu @{Signup}
    var cities = ["Berkeley", "Fremont", "Irvine", "Los Angeles", "Oakland",
        "Palo Alto", "Pleasanton", "Riverside", "San Francisco", "San Jose"]
    
    init() {
        makeUserLists()
    }
    
    // getUserIndex is called only once @{Login}
    func getUserIndex(id: String) -> User {
        
        // loop through list to check id
        for index in 0...userList.count {
            if id == userList[index].id {
                thisUser = index
            }
       }// index all lists with thisUser
        return userList[thisUser]
    }
    
    // makeUserLists is called only once @{init}
    func makeUserLists() {
        
        // remove from all lists = no duplicates
        userList.removeAll()
        userData.removeAll()
        profiles.removeAll()
        settings.removeAll()
        
        let FS = Firestore.firestore()
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
                
                let data2 = UserData(id: id, favorites: favorites,
                    following: following, chatting: chatting, blocked: blocked)
                self.userData.append(data2)
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
        
        FS.collection("settings").getDocuments { collection, error in
            
            for document in collection!.documents {
                let data = document.data()
                
                let id       = data["id"]       as! String
                let notifs   = data["notifs"]   as! Bool
                let emails   = data["emails"]   as! Bool
                let privacy  = data["privacy"]  as! Bool
                let location = data["location"] as! Bool
                
                let setting = Setting(id: id, notifs: notifs, emails: emails,
                                      privacy: privacy, location: location)
                self.settings.append(setting)
            }
        }
        // sort all lists to index with thisUser
        userList.sort { $0.id < $1.id }
        userData.sort { $0.id < $1.id }
        profiles.sort { $0.id < $1.id }
        settings.sort { $0.id < $1.id }
    }
    
    // makeNewUser is called only once @{Signup}
    func makeNewUser(id: String, name: String, image: String, city: String) {
        
        let FS = Firestore.firestore()
        // 1. access firebase collection
        // 2. make new document with {id}
        // 3. setData to document values
        
        let user = FS.collection("users").document(id)
        user.setData(["id": id, "name": name, "image": image, "city": city])
        
        let data = FS.collection("userDatas").document(id)
        data.setData(["id": id, "favorites": [String](), "following": [String](),
                           "chatting": [String](), "blocked": [String]()])
        
        let profile = FS.collection("profiles").document(id)
        profile.setData(["id": id, "name": name, "image": "replaceThis", // TODO: fix image directory string
                          "bio": "Add a bio", "swipes": 0])
        
        let setting = FS.collection("settings").document(id)
        setting.setData(["id": id, "notifs": true, "emails": true,
                         "privacy": true, "location": true])
    }
    
    // deleteProfile is called by button @{Self}
    func deleteProfile(id: String) {
        
        // access firebase documents <- collection "profiles"
        let FS = Firestore.firestore()
        let oldDoc = FS.collection("profiles").document(id)
        
        // delete document (was selection, not creation)^^^
        oldDoc.delete()
    }
}
