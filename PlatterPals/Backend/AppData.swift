import SwiftUI

let UIwidth = UIScreen.main.bounds.size.width
let UIheight = UIScreen.main.bounds.size.height

let cityList = ["Berkeley", "Fremont", "Oakland", "Palo Alto",
                "Pleasanton", "San Francisco", "San Jose"]

let foodList = ["All", "American", "Brazilian", "Caribbean", "Chinese",
                "Ethiopian", "French", "Indian", "Italian", "Japanese",
                "Korean", "Mexican", "Middle Eastern", "Thai", "Vietnamese"]

extension SetItem {
    static let data = [
        SetItem(title: "Chats", text: "Blocked users, notifications", image: "message"),

        SetItem(title: "Feed", text: "Swipe history, profile suggests", image: "house"),

        SetItem(title: "Profile", text: "Profile picture, bio, publicity", image: "person"),

        SetItem(title: "Security", text: "Payment methods, login info", image: "lock"),

        SetItem(title: "Account", text: "Link to DoorDash, deletion", image: "key"),
    ]
}

struct User: Identifiable, Hashable {
    let id: String
    let name: String
    let image: String
    let city: String
}

struct UserData: Identifiable {
    let id: String
    var favorites: [String]
    let following: [String]
    let chatting: [String]
    let blocked: [String]
}

struct Profile: Identifiable {
    let id: String
    let image: String
    let city: String
    let text: String
    let likes: Int
}

struct Message: Identifiable {
    let id: String
    let text: String
    let sender: String
    let getter: String
    let time: Date
}

struct AIOrder: Identifiable {
    let id: String
    let order: String
    let location: String
    let rating: Int
    let time: Date
}

struct Setting: Identifiable {
    var id: String = ""
    var notifs = true
    var emails = true
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
