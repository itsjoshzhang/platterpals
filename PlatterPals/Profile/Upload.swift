import SwiftUI
import PhotosUI

struct Upload: View {

    // ## IMAGE VARS ## \\
    @State var text = ""
    @State var image: UIImage?
    @State var showCrop = false
    @FocusState var focus: Bool
    @State var imageItem: PhotosPickerItem?

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager

    // ## SETUP VIEW ## \\
    var body: some View {
        NavigationStack {
            var my = DM.my()
        ScrollView {
        VStack(spacing: 16) {

        // ## SHOW IMAGE ## \\

        if let image = image {
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
        // ## UPLOAD PIC ## \\

        Text("Use template for best result")
            .foregroundColor(.secondary)
            .font(.subheadline)

        HStack {
            PhotosPicker("Upload Picture", selection: $imageItem,
                         matching: .images)

            if image != nil {
                Button("\(Image(systemName: "crop"))") {
                    showCrop = true
        }}}
        .buttonStyle(.bordered)

        .onChange(of: imageItem) { _ in
            imageItem?.loadTransferable(type: Data.self) { result in

                switch result {
                case .success(let data):
                    image = UIImage(data: data ?? Data())
                case .failure(_):
                    return
                }}}
            
        // ## CLICKABLES ## \\

        TextEditor(text: $text)
            .frame(minHeight: UIwidth * 0.25)
            .focused($focus)
            .border(UIgray)
            .onTapGesture {
                focus = true
            }
        if text.count > 200 {
            Text("200 chars max")
                .foregroundColor(.secondary)
        } else {
            Button("Save Edits") {
                if let image = image {
                    DM.putImage(image: image, path: "profiles")
                }
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .disabled(text.isEmpty)
        }
        }
        // ## MODIFIERS ## \\

        .padding(16)
        .navigationTitle("Profile 📸")
        .background {
            Back()
        }
        .onAppear {
            text = my.text
        }
        .onTapGesture {
            focus = false
        }
        .fullScreenCover(isPresented: $showCrop) {
            ImageEditor(image: $image, show: $showCrop)
        }}}}}
