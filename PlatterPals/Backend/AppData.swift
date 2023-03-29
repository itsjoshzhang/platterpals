import SwiftUI

let UIwidth = UIScreen.main.bounds.size.width
let UIheight = UIScreen.main.bounds.size.height

let cityList = ["Berkeley", "Fremont", "Oakland", "Palo Alto",
                "Pleasanton", "San Francisco", "San Jose"]

let foodList = ["All", "American", "Brazilian", "Caribbean", "Chinese",
                "Ethiopian", "French", "Indian", "Italian", "Japanese",
                "Korean", "Mexican", "Middle Eastern", "Thai", "Vietnamese"]

extension UIImage {
    // input: new width and pfp(t/f)
    func resize(width: CGFloat, pfp: Bool = false) -> UIImage {

        // compute new scale and height
        let scale = width / self.size.width
        var height = self.size.height * scale

        // user avatars should be square
        if pfp {
            height = width
        }
        // compute new size and renderer
        let size = CGSize(width: width, height: height)
        let render = UIGraphicsImageRenderer(size: size)

        // return rendered resized image
        return render.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
extension SetItem {
    static let items = [
        SetItem(title: "Chats", text: "Blocked users & notifications", image: "message"),

        SetItem(title: "Home", text: "Suggested users & restaurants", image: "house"),

        SetItem(title: "Profile", text: "Profile image, bio, publicity", image: "person"),

        SetItem(title: "Security", text: "Login info & payment methods", image: "lock"),

        SetItem(title: "Account", text: "Upload data & delete account", image: "key"),
    ]
}

struct User: Identifiable, Hashable {
    let id: String
    var name: String
    var text: String
    var city: String
    var views: Int
}

struct UserData: Identifiable {
    let id: String
    var favFoods: [String]
    var favUsers: [String]
    var chatting: [String]
    var blocked: [String]
}

struct Message: Identifiable, Hashable {
    let id: String
    let text: String
    let sender: String
    let getter: String
    let time: Date
}

struct AIOrder: Identifiable {
    let id: String
    let order: String
    let place: String
    let rating: Int
    let time: Date
}

struct Setting: Identifiable{
    var id = ""
    var notifs = true
    var emails = true
    var privacy = true
    var location = true
}

struct SetItem: Hashable {
    let title: String
    let text: String
    let image: String
}

struct Div: View {
    var body: some View {
        Divider()
            .frame(height: 3)
            .overlay(.pink)
    }
}
struct Back: View {
    var body: some View {
        Image("back")
            .resizable()
            .opacity(0.05)
            .scaledToFill()
            .ignoresSafeArea()
    }
}
struct RoundPic: View {
    var image: UIImage?
    var width: Int

    var body: some View {
        Image(uiImage: image!)
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .frame(width: CGFloat(width))
    }
}
