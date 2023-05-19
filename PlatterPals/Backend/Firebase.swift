import SwiftUI
import Firebase
import FirebaseStorage

// start firebase
let FS = Firestore.firestore()
let SR = Storage.storage().reference()

class DataManager: ObservableObject {

    // track user data
    @Published var userList = [User]()
    @Published var userData = [UserData]()
    @Published var settings = Setting()

    @Published var myIndex = 0
    @Published var myAvatar: UIImage?
    @Published var myProfile: UIImage?

    init() { initInfo() }

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

        let id       = data["id"]       as? String   ?? ""
        let favFoods = data["favFoods"] as? [String] ?? [String]()
        let favUsers = data["favUsers"] as? [String] ?? [String]()
        let chatting = data["chatting"] as? [String] ?? [String]()
        let blocked  = data["blocked"]  as? [String] ?? [String]()

        let userData = UserData(id: id, favFoods: favFoods, favUsers:
                       favUsers, chatting: chatting, blocked: blocked)
        self.userData.append(userData)
        }}}

    // called at Login
    func initUser(id: String) {
        for i in 0 ..< userList.count {
            if userList[i].id == id {
                myIndex = i
                break }}
        getImage(path: "avatars")
        getImage(path: "profiles")
        getSetts(id: id)
    }
    
    // called at Signup
    func makeUser(id: String, name: String, city: String) {

        let user = User(id: id, name: name, text: "", city: city)
        editUser(user: user)

        let data = UserData(id: id, favFoods: [String](), favUsers:
            [String](), chatting: [String](), blocked: [String]())
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
            user.text, "city": user.city])
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
    func findHearts(id: String) -> Int {
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

        // resize jpg image
        let image = image.resize(width: 200, pfp: pfp)
        let jpeg = image.jpegData(compressionQuality: 1)

        // compute metadata
        let meta = StorageMetadata()
        meta.contentType = "image/jpg"

        // put into storage
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

    // called at Profile
    func delImage(path: String) {
        let SR = SR.child("\(path)/\(my().id).jpg")
        SR.delete {_ in}
    }

    // called at init
    func getSetts(id: String) {
        FS.collection("settings").addSnapshotListener { snap, error in
        var setsList = snap!.documents.compactMap { doc -> Setting? in

        if let sets = try? doc.data(as: Setting.self) {
            if (sets.id == id) {
                return sets }}
        return nil
        }
        self.settings = setsList.first ?? Setting()
    }}}
