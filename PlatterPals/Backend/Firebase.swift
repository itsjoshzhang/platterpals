import SwiftUI
import Firebase
import FirebaseStorage

// start Firebase
let FS = Firestore.firestore()
let SR = Storage.storage().reference()

class DataManager: ObservableObject {

    // track user info
    @Published var userList = [User]()
    @Published var userData = [UserData]()
    @Published var settings = Setting()

    // keep user info
    var version = -1
    var myIndex = 0
    @Published var myAvatar: UIImage?
    @Published var myProfile: UIImage?

    init() {
        initInfo()
    }
    // returns myself
    func my() -> User {
        return userList[myIndex]
    }
    // return my data
    func md() -> UserData {
        return userData[myIndex]
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

    // called at init
    private func initInfo() {

        // access userList
        FS.collection("userList").getDocuments { col,_ in

            if let col = col {
            for doc in col.documents {
            let data = doc.data()

            let id   = data["id"]   as? String ?? ""
            let name = data["name"] as? String ?? ""
            let city = data["city"] as? String ?? ""
            let text = data["text"] as? String ?? ""
            let prof = data["prof"] as? Int ?? 0

            let user = User(id: id, name: name, city: city, text:
                            text, prof: prof)
            self.userList.append(user)
        }}}

        // access userData
        FS.collection("userData").getDocuments { col,_ in
            if let col = col {
            for doc in col.documents {
            let data = doc.data()

            let id       = data["id"]       as? String   ?? ""
            let favFoods = data["favFoods"] as? [String] ?? [String]()
            let chatting = data["chatting"] as? [String] ?? [String]()
            let favUsers = data["favUsers"] as? [String] ?? [String]()
            let blocked  = data["blocked"]  as? [String] ?? [String]()

            let userData = UserData(id: id, favFoods: favFoods,
            chatting: chatting, favUsers: favUsers, blocked: blocked)
            self.userData.append(userData)
        }}}

        // update version
        let doc = FS.collection("accFlags").document("APP_UPDATE")
        doc.getDocument { doc,_ in
            self.version = doc?.data()?["version"] as? Int ?? -1
        }
    }
    // called at init
    private func getSetts() {
        FS.collection("settings").getDocuments { col,_ in

        if let col = col {
        for doc in col.documents {
        let data = doc.data()
            let id      = data["id"]      as? String ?? " "

        if self.my().id == id {
            let notifs  = data["notifs"]  as? Bool ?? true
            let suggest = data["suggest"] as? Bool ?? true
            let privacy = data["privacy"] as? Bool ?? true
            let locate  = data["locate"]  as? Bool ?? true

            self.settings = Setting(id: id, notifs: notifs, suggest:
                            suggest, privacy: privacy, locate: locate)
            }}}}}

    // called at Login
    func initUser(id: String) {
        for i in 0 ..< userList.count {
            if userList[i].id == id {
                myIndex = i
                break }}
        getImage(path: "avatars")
        getImage(path: "profiles")
        getSetts()
    }
    
    // called at Signup
    func makeUser(id: String, name: String, city: String) {

        let user = User(id: id, name: name, city: city, text: "",
                        prof: 0)
        editUser(user: user)

        let data = UserData(id: id, favFoods: [String](), chatting:
            [String](), favUsers: [String](), blocked: [String]())
        editData(data: data)

        let sets = Setting(id: id, notifs: true, suggest: true,
                           privacy: true, locate: true)
        editSets(sets: sets)
    }
    
    // called at Profile
    func editUser(user: User) {
        let doc = FS.collection("userList").document(user.id)
        userList[myIndex] = user

        doc.setData(["id": user.id, "name": user.name, "text":
            user.text, "city": user.city, "prof": user.prof])
    }
    
    // called everywhere
    func editData(data: UserData) {
        let doc = FS.collection("userData").document(data.id)
        userData[myIndex] = data
        
        doc.setData(["id": data.id, "favFoods": data.favFoods, "favUsers":
        data.favUsers, "chatting": data.chatting, "blocked": data.blocked])
    }
    
    // called at Settings
    func editSets(sets: Setting) {
        let doc = FS.collection("settings").document(sets.id)
        settings = sets
        
        doc.setData(["id": sets.id, "notifs": sets.notifs, "suggest":
        sets.suggest, "privacy": sets.privacy, "locate": sets.locate])
    }

    // called at Convo
    func sendChat(msg: Message) {
        let doc = FS.collection("messages").document(msg.id)
        
        doc.setData(["id": msg.id, "text": msg.text, "sender":
            msg.sender, "getter": msg.getter, "time": msg.time])
    }
    
    // called at Order
    func sendOrder(ord: AIOrder) {
        let doc = FS.collection("aiOrders").document(ord.id)
        
        doc.setData(["id": ord.id, "user": ord.user, "order": ord.order,
            "place": ord.place, "stars": ord.stars, "time": ord.time])
    }

    // called at Update
    func sumHeart(id: String) -> Int {
        var hearts = 0
        for data in userData {
            if data.favUsers.contains(id) {
                hearts += 1 }}
        return hearts
    }

    // called everywhere
    func putImage(image: UIImage, path: String) {

        // get storage path
        let SR = SR.child("\(path)/\(my().id).jpg")
        let pfp = (path == "avatars")

        // resize the image
        let width = min(image.size.width, 1024)
        let image = image.resize(width: width, pfp: pfp)

        // compute metadata
        let meta = StorageMetadata()
        meta.contentType = "image/jpg"
        let jpeg = image.jpegData(compressionQuality: pfp ? 0.25: 1)

        // put into storage
        if let jpeg = jpeg {
            SR.putData(jpeg, metadata: meta)
        }
        // update prof value
        if !pfp {
            userList[myIndex].prof = -1
            editUser(user: my())
        }
    }
    // called at init
    func getImage(path: String) {
        let SR = SR.child("\(path)/\(my().id).jpg")
        SR.getData(maxSize: 4 * 1024 * 1024) { data,_ in
        if let data = data {

        if path == "avatars" {
            self.myAvatar = UIImage(data: data)
        } else {
            self.myProfile = UIImage(data: data)
        }}}}

    // called at Profile
    func delImage(path: String) {
        let SR = SR.child("\(path)/\(my().id).jpg")
        SR.delete {_ in}

        userList[myIndex].prof = 4
        editUser(user: my())
    }

    // called at Maps
    func sendPin(pin: Location) {
        let doc = FS.collection("mapPins").document(pin.id)

        doc.setData(["id": pin.id, "lat": pin.lat, "lon": pin.lon,
                     "time": pin.time])
    }

    // called at Update
    func sendFlag(id: String, type: String) {
        let doc = FS.collection("accFlags").document(id)

        doc.setData(["id": id, "type": type, "user": my().id,
                     "time": Date()])
    }
}
