import SwiftUI
import Mantis

struct Test: View {
    @State var image = UIImage(named: "guide1")
    @State var isShowing = false

    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            }
            Button("Crop") {
                isShowing = true
            }
            .fullScreenCover(isPresented: $isShowing) {
                ImageEditor(theimage: $image, isShowing: $isShowing)
            }}}}

struct ImageEditor: UIViewControllerRepresentable {
    typealias Coordinator = ImageEditorCoordinator
    @Binding var theimage: UIImage?
    @Binding var isShowing: Bool

    func makeCoordinator() -> ImageEditorCoordinator {
        return ImageEditorCoordinator(image: $theimage, isShowing: $isShowing)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageEditor>) -> CropViewController {
        let Editor = cropViewController(image: theimage!)
        Editor.delegate = context.coordinator
        return Editor
    }
}

class ImageEditorCoordinator: NSObject, CropViewControllerDelegate {
    @Binding var theimage: UIImage?
    @Binding var isShowing: Bool

    init(image: Binding<UIImage?>, isShowing: Binding<Bool>) {
        _theimage = image
        _isShowing = isShowing
    }
    func cropViewControllerDidCrop (_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation, cropInfo: CropInfo) {
        theimage = cropped
        isShowing = false
    }

    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        isShowing = false
    }
}
