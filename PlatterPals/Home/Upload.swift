import SwiftUI
import PhotosUI

struct Upload: View {

    @State var text: String = ""
    @State var imageData: Data?
    @State var imageItem: PhotosPickerItem?
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
        ZStack {
        Back()
        ScrollView {
        VStack(spacing: 10) {
        Spacer()
            .padding(40)

        if let d = imageData, let image = UIImage(data: d) {

            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: UIheight * 0.75)
        } else {
            ZStack {
                Rectangle()
                    .fill(.white)
                Image("upload")
                    .resizable()
                    .opacity(0.25)
                    .border(.pink, width: 3)
            }
            .scaledToFit()
            .frame(maxHeight: UIheight * 0.5)
        }
        Text("Use template for best result")
            .foregroundColor(.secondary)

        PhotosPicker("Upload Picture", selection: $imageItem,
                     matching: .images)
        .buttonStyle(.bordered)

        .onChange(of: imageItem) { _ in
            imageItem?.loadTransferable(type: Data.self) { result in

                switch result {
                case .success(let data):
                    imageData = data
                case .failure(_):
                    return
                }
            }
        }
        TextEditor(text: $text)
            .border(.secondary.opacity(0.25))
            .frame(minHeight: UIwidth * 0.25)

        if text.count > 200 {
            Text("200 chars max")
                .foregroundColor(.secondary)
        } else {
            Button("Save Edits") {
                if let d = imageData, let image = UIImage(data: d) {
                    DM.putImage(image: image, path: "avatars")
                }
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .disabled(text == "")
        }
        Spacer()
            .padding(16)
        }
        .padding(16)
        }
        .navigationTitle("Profile 📸")
        .onAppear {
            text = DM.my().text
        }}}}}
