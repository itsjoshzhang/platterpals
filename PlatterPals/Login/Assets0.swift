import SwiftUI
import Mantis

// MARK: - implement a numerical page tracking system where the number of tasks completed are saved to the user's firebase

struct Guide: View {
    var body: some View {
        TabView {
            Guide2(image: 1, title: "Welcome to PlatterPals!",
            text: "Find food and restaurants in your area using an intelligent AI. Make friends with similar palates and meet your culinary soulmate!")

            Guide2(image: 2, title: "Can't decide what to eat?",
            text: "Let your GPT-powered AI assistant generate the perfect order. Just fill in your favorite cuisines and follow some foodies near you!")

            Guide2(image: 3, title: "Go find your PlatterPal!",
            text: "We've made it easy to match with people who meet your tastes. Simply swipe left on a profile to remove and swipe right to approve!")
        }
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}
struct Guide2: View {
    
    var image: Int
    var title: String
    var text: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 16) {

            if image == 3 {
                Text("").padding(10)
            }
            Image("guide\(image)")
                .resizable()
                .scaledToFit()
            
            Text(title)
                .foregroundColor(.pink)
                .font(.title).bold()
            
            Text(text)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            if image == 3 {
                Button("Get Started") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }}.padding(16)}}

struct Terms: View {
    var body: some View {
        NavigationStack {
        VStack(spacing: 16) {

        Text("PlatterPals displays user-generated content. This includes other users and yourself. We take specific steps to moderate content and prevent abusive behavior.")

        Text("There is no tolerance for objectionable content or abusive users. This includes profiles and chats that have offensive content or are unsuitable for viewing.")

        Text("Users may filter such content and hide specific profiles, flag users on any of their pages / posts, and block abusive accounts in the profile and chat pages.")

        Text("PlatterPals will act on such content within 24 hours by removing it and banning the flagged user. For support or inquiries, please visit www.platterpals.com.")
        }
        .padding(16)
        .navigationTitle("Terms and EULA")
        .foregroundColor(.secondary)
        .background {
            Back()
        }}}}

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
