import SwiftUI
import Mantis

let UIwidth = UIScreen.main.bounds.size.width
let UIheight = UIScreen.main.bounds.size.height
let UIgray = Color.secondary.opacity(0.25)

let cityList = ["Berkeley", "Fremont", "Palo Alto", "San Fran.", "San Jose", "More..."]

let allCities = ["Berkeley", "Fremont", "Irvine", "Los Angeles", "Oakland", "Palo Alto",
                 "Pleasanton", "Riverside", "Sacramento", "San Diego", "San Francisco",
                 "San Jose", "San Mateo", "Santa Barbara", "Santa Cruz", "More..."]

let foodList = ["All", "American", "Boba Tea", "Brazilian", "Caribbean", "Chinese",
                "Ethiopian", "Hawaiian", "French", "Indian", "Italian", "Japanese",
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
            let w = CGFloat(width)
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
        .frame(width: w, height: w)
        .clipShape(Circle())
        .clipped()
    }}}

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
        }}}

struct User: Identifiable, Hashable, Codable {
    let id: String
    var name: String
    var city: String
    var text: String
    var prof: Int
}

struct UserData: Identifiable, Hashable, Codable {
    let id: String
    var favFoods: [String]
    var chatting: [String]
    var favUsers: [String]
    var blocked: [String]
}

struct Message: Identifiable, Hashable, Codable {
    var id = UUID().uuidString
    let text: String
    let sender: String
    let getter: String
    var time = Date()
}

struct AIOrder: Identifiable, Hashable, Codable {
    var id = UUID().uuidString
    let user: String
    let order: String
    let place: String
    var stars: Int
    var time = Date()
}

struct Setting: Identifiable, Hashable, Codable {
    var id = " "
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
struct ImageEditor: UIViewControllerRepresentable {
    typealias Coordinator = ImageEditorCoordinator
    @Binding var image: UIImage?
    @Binding var show: Bool

    func makeCoordinator() -> ImageEditorCoordinator {
        return ImageEditorCoordinator(image: $image, show: $show)
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageEditor>) -> CropViewController {
        let Editor = cropViewController(image: image ?? UIImage())
        Editor.delegate = context.coordinator
        return Editor
    }
}
class ImageEditorCoordinator: NSObject, CropViewControllerDelegate {
    @Binding var image: UIImage?
    @Binding var show: Bool

    init(image: Binding<UIImage?>, show: Binding<Bool>) {
        _image = image
        _show = show
    }
    func cropViewControllerDidCrop (_ cropViewController:
        CropViewController, cropped: UIImage, transformation:
        Transformation, cropInfo: CropInfo) {
        image = cropped
        show = false
    }
    func cropViewControllerDidCancel(_ cropViewController:
        CropViewController, original: UIImage) {
        show = false
    }
}
