import SwiftUI

let UIwidth = UIScreen.main.bounds.size.width
let UIheight = UIScreen.main.bounds.size.height
let UIgray = Color.secondary.opacity(0.25)

let cityList = ["Berkeley", "Fremont", "Oakland", "Palo Alto",
                "Pleasanton", "San Francisco", "San Jose"]

let foodList = ["All", "American", "Boba Tea", "Caribbean", "Chinese",
                "Ethiopian", "French", "Indian", "Italian", "Japanese",
                "Korean", "Mexican", "Middle Eastern", "Thai", "Vietnamese"]

let emojiList = ["🥡", "🧋", "🍵", "☕️", "🥐", "🥯", "🥞", "🧇",
                 "🌭", "🍔", "🍟", "🍕", "🥩", "🍗", "🥪", "🧆",
                 "🌯", "🥗", "🍝", "🍜", "🍲", "🍣", "🍱", "🥟",
                 "🍅", "🥑", "🥬", "🌶", "🍦", "🍩", "🍪", "🍰"]

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
                    .foregroundColor(UIgray)
            }
        }
        .scaledToFit()
        .frame(width: CGFloat(width))
        .clipShape(Circle())
        .clipped()
    }
}
extension UIImage {

    // called at putImage
    func resize(width: CGFloat, pfp: Bool) -> UIImage {

        // compute new scale
        var height = width * 16.0 / 9.0
        if pfp { height = width }

        // render new size
        let size = CGSize(width: width, height: height)
        let render = UIGraphicsImageRenderer(size: size)

        // return new image
        return render.image {_ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
struct User: Identifiable, Hashable {
    let id: String
    var name: String
    var text: String
    var city: String
    var prof: Bool
}

struct UserData: Identifiable, Hashable {
    let id: String
    var favFoods: [String]
    var favUsers: [String]
    var chatting: [String]
    var blocked: [String]
}

struct Message: Identifiable, Hashable, Codable {
    var id = UUID().uuidString
    let text: String
    let sender: String
    let getter: String
    let time: Date
}

struct AIOrder: Identifiable, Hashable, Codable {
    var id = UUID().uuidString
    let user: String
    let order: String
    let place: String
    var stars: Int
    let time: Date
}

struct Setting: Identifiable, Hashable, Codable {
    var id = ""
    var notifs = true
    var suggest = true
    var privacy = true
    var locate = true
}

struct Div: View {
    var body: some View {
        Divider()
            .frame(maxWidth: UIwidth, minHeight: 3)
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
            .frame(width: UIwidth-32, height: 32, alignment: .leading)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(.secondary))
    }
}
