import SwiftUI

let UIwidth = UIScreen.main.bounds.size.width
let UIheight = UIScreen.main.bounds.size.height

let image = UIImage()

extension UIImage {
    func resize(width: CGFloat, pfp: Bool = false) -> UIImage {

        let scale = width / self.size.width
        var height = self.size.height * scale

        if pfp {
            height = width
        }
        let size = CGSize(width: width, height: height)
        let image = UIGraphicsImageRenderer(size: size)

        return image.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

struct RoundPic: View {
    var image: UIImage?
    var width: Int

    var body: some View {
        if let image = image {

            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: CGFloat(width))
        } else {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: CGFloat(width))
        }
    }
}

let cityList = ["Berkeley", "Fremont", "Oakland", "Palo Alto",
                "Pleasanton", "San Francisco", "San Jose"]

let foodList = ["All", "American", "Brazilian", "Caribbean", "Chinese",
                "Ethiopian", "French", "Indian", "Italian", "Japanese",
                "Korean", "Mexican", "Middle Eastern", "Thai", "Vietnamese"]

extension SetItem {
    static let items = [
        SetItem(title: "Chats", text: "Blocked users & notifications", image: "message"),

        SetItem(title: "Home", text: "Suggested users & restaurants", image: "house"),

        SetItem(title: "Profile", text: "Profile image, bio, publicity", image: "person"),

        SetItem(title: "Security", text: "Login info & payment methods", image: "lock"),

        SetItem(title: "Account", text: "Delete account & upload data", image: "key"),
    ]
}

struct User {
    let id: String
    var name: String
    var text: String
    var city: String
    var views: Int
}

struct UserData {
    let id: String
    var favFoods: [String]
    var favUsers: [String]
    var chatting: [String]
    var blocked: [String]
}

struct Message {
    let id = UUID().uuidString
    let text: String
    let sender: String
    let getter: String
    let time: Date
}

struct AIOrder {
    let id = UUID().uuidString
    let order: String
    let place: String
    let rating: Int
    let time: Date
}

struct Setting {
    let id = ""
    var notifs = true
    var emails = true
    var privacy = true
    var location = true
}

struct SetItem {
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
