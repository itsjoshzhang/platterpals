import SwiftUI
import Firebase
import FirebaseStorage

let FS = Firestore.firestore()
let SR = Storage.storage().reference()

class DataManager: ObservableObject {

    @Published var userList = [User]()
    @Published var userData = [UserData]()
    @Published var settings = [Setting]()

    var version = -1
    var myIndex = 0
    var aiModel = "gpt-3.5-turbo"
    @Published var myAvatar: UIImage?
    @Published var myProfile: UIImage?

    init() {
        initInfo()
    }
    func my() -> User {
        return userList[myIndex]
    }
    func md() -> UserData {
        return userData[myIndex]
    }
    func ms() -> Setting {
        return settings[myIndex]
    }
    func user(id: String) -> User {
        for user in userList {
            if (user.id == id || user.name == id) {
                return user }}
        return my()
    }
    func data(id: String) -> UserData {
        for data in userData {
            if data.id == id {
                return data }}
        return md()
    }
    func sets(id: String) -> Setting {
        for sett in settings {
            if sett.id == id {
                return sett }}
        return ms()
    }

    private func initInfo() {

        let doc = FS.collection("accFlags").document("APP_STATUS")
        doc.getDocument { doc,_ in
            self.version = doc?.data()?["version"] as? Int ?? 0
            if let aiModel = doc?.data()?["aiModel"] as? String {
                self.aiModel = aiModel
            }
        }
        FS.collection("userList").getDocuments { col,_ in

        if let col = col {
        for doc in col.documents {
        let data = doc.data()

            let id   = data["id"]   as? String ?? ""
            let name = data["name"] as? String ?? ""
            let city = data["city"] as? String ?? ""
            let text = data["text"] as? String ?? ""
            let prof = data["prof"] as? Bool   ?? false
            let rest = data["rest"] as? Bool   ?? false

        let user = User(id: id, name: name, city: city, text: text,
                        prof: prof, rest: rest)
        self.userList.append(user)
        }}}

        FS.collection("userData").getDocuments { col,_ in
        if let col = col {
        for doc in col.documents {
        let data = doc.data()

            let id       = data["id"]       as? String   ?? ""
            let favFoods = data["favFoods"] as? [String] ?? [String]()
            let chatting = data["chatting"] as? [String] ?? [String]()
            let favUsers = data["favUsers"] as? [String] ?? [String]()
            let blocked  = data["blocked"]  as? [String] ?? [String]()

        let userData = UserData(id: id, favFoods: favFoods, chatting:
                       chatting, favUsers: favUsers, blocked: blocked)
        self.userData.append(userData)
        }}}

        FS.collection("settings").getDocuments { col,_ in
        if let col = col {
        for doc in col.documents {
        let data = doc.data()

            let id      = data["id"]      as? String ?? ""
            let notifs  = data["notifs"]  as? Bool ?? true
            let locate  = data["locate"]  as? Bool ?? true
            let suggest = data["suggest"] as? Bool ?? true
            let privacy = data["privacy"] as? Bool ?? false

        let setting = Setting(id: id, notifs: notifs, locate: locate,
                              suggest: suggest, privacy: privacy)
        self.settings.append(setting)
        }}}}

    func initUser(id: String) {
        for i in 0 ..< userList.count {
            if userList[i].id == id {
                myIndex = i
                break }}
        getImage(path: "avatars")
        getImage(path: "profiles")
    }

    func makeUser(id: String, name: String, city: String, rest: Bool) {

        let user = User(id: id, name: name, city: city, text: "",
                        prof: false, rest: rest)
        editUser(user: user)

        let data = UserData(id: id, favFoods: [String](), chatting:
            [String](), favUsers: [String](), blocked: [String]())
        editData(data: data)

        let sets = Setting(id: id, notifs: true, locate: true,
                           suggest: true, privacy: false)
        editSets(sets: sets)
    }

    func editUser(user: User) {
        let doc = FS.collection("userList").document(user.id)
        userList[myIndex] = user

        doc.setData(["id": user.id, "name": user.name, "text":
            user.text, "city": user.city, "prof": user.prof,
            "rest": user.rest])
    }

    func editData(data: UserData) {
        userData[myIndex] = data
        sendData(data: data)
    }
    private func sendData(data: UserData) {
        let doc = FS.collection("userData").document(data.id)

        doc.setData(["id": data.id, "favFoods": data.favFoods, "favUsers":
        data.favUsers, "chatting": data.chatting, "blocked": data.blocked])
    }

    func editSets(sets: Setting) {
        let doc = FS.collection("settings").document(sets.id)
        settings[myIndex] = sets
        
        doc.setData(["id": sets.id, "notifs": sets.notifs, "suggest":
        sets.suggest, "privacy": sets.privacy, "locate": sets.locate])
    }

    func sendChat(msg: Message) {
        let doc = FS.collection("messages").document(msg.id)
        
        doc.setData(["id": msg.id, "text": msg.text, "sender":
            msg.sender, "getter": msg.getter, "time": msg.time])

        var get = data(id: msg.getter)
        if let i = get.chatting.firstIndex(of: msg.sender) {
            get.chatting.remove(at: i)
        }
        get.chatting.insert(msg.sender, at: 0)
        sendData(data: get)
    }

    func sendOrder(ord: AIOrder) {
        let doc = FS.collection("aiOrders").document(ord.id)
        
        doc.setData(["id": ord.id, "user": ord.user, "order": ord.order,
            "place": ord.place, "stars": ord.stars, "time": ord.time])
    }

    func sumHeart(id: String) -> Int {
        var hearts = 0
        for data in userData {
            if data.favUsers.contains(id) {
                hearts += 1 }}
        return hearts
    }

    func putImage(image: UIImage, path: String) {

        let SR = SR.child("\(path)/\(my().id).jpg")
        let pfp = (path == "avatars")

        let width = min(image.size.width, 500)
        let image = image.resize(width: width, pfp: pfp)

        let meta = StorageMetadata()
        meta.contentType = "image/jpg"
        let jpeg = image.jpegData(compressionQuality: 0.2)

        if let jpeg = jpeg {
            SR.putData(jpeg, metadata: meta)
        }
        if pfp {
            myAvatar = image
        } else {
            userList[myIndex].prof = true
            editUser(user: my())
            myProfile = image
        }
    }
    func getImage(path: String) {
        let SR = SR.child("\(path)/\(my().id).jpg")
        SR.getData(maxSize: 4 * 1024 * 1024) { data,_ in
        if let data = data {

        if path == "avatars" {
            self.myAvatar = UIImage(data: data)
        } else {
            self.myProfile = UIImage(data: data)
        }}}}

    func delImage(path: String) {
        let SR = SR.child("\(path)/\(my().id).jpg")
        SR.delete {_ in}

        if path != "avatars" {
            userList[myIndex].prof = false
            editUser(user: my())
        }
    }
    func sendPin(pin: Location) {
        let doc = FS.collection("mapPins").document(pin.id)

        doc.setData(["id": pin.id, "lat": pin.lat, "lon": pin.lon,
                     "time": pin.time])
    }

    func sendFlag(id: String, type: String) {
        let doc = FS.collection("accFlags").document(id)

        doc.setData(["id": id, "type": type, "user": my().id,
                     "time": Date()])
    }
}
