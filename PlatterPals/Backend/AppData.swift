import SwiftUI

// ## GLOBAL VARS ## \\

let UIwidth = UIScreen.main.bounds.size.width
let UIheight = UIScreen.main.bounds.size.height
let gray = Color.secondary.opacity(0.25)

let cityList = ["Berkeley", "Fremont", "Oakland", "Palo Alto",
                "Pleasanton", "San Francisco", "San Jose"]

let foodList = ["All", "American", "Brazilian", "Caribbean", "Chinese",
                "Ethiopian", "French", "Indian", "Italian", "Japanese",
                "Korean", "Mexican", "Middle Eastern", "Thai", "Vietnamese"]

struct RoundPic: View {
    var width: Int
    var image: UIImage?

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Image(systemName: "person.circle")
                    .resizable()
                    .opacity(0.25)
                    .foregroundColor(.secondary)
            }
        }
        .scaledToFit()
        .clipShape(Circle())
        .frame(width: CGFloat(width))
    }
}
extension UIImage {

    // called at putImage
    func resize(width: CGFloat, pfp: Bool) -> UIImage {

        // compute new scale and height
        var height = width * 16.0 / 9.0
        if pfp { height = width }

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
        SetItem(title: "Home", text: "Following users & restaurants", image: "house"),
        SetItem(title: "Orders", text: "Order history & favorite foods", image: "person"),
        SetItem(title: "Security", text: "Signin info & account privacy", image: "lock"),
        SetItem(title: "Account", text: "Upload data or delete account", image: "key"),
    ]
}

struct User: Identifiable, Hashable {
    let id: String
    var name: String
    var text: String
    var city: String
    var views: Int
}

struct UserData: Identifiable, Hashable {
    let id: String
    var favFoods: [String]
    var favUsers: [String]
    var chatting: [String]
    var blocked: [String]
}

struct Message: Identifiable, Hashable, Codable {
    let id: String
    let text: String
    let sender: String
    let getter: String
    let time: Date
}

struct AIOrder: Identifiable, Hashable {
    let id: String
    let order: String
    let place: String
    let rating: Int
    let time: Date
}

struct Setting: Identifiable, Hashable {
    var id = ""
    var notifs = true
    var suggest = true
    var privacy = true
    var location = true
}

struct SetItem: Identifiable, Hashable {
    let id = UUID()
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
struct Box: View {
    var body: some View {
        Text("Search for a user:")
            .padding(.leading, 8)
            .foregroundColor(.secondary)
            .frame(width: UIwidth - 32, height: 32,
                   alignment: .leading)
            .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(.secondary))
    }
}
