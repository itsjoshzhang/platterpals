import SwiftUI
import PhotosUI

struct Upload: View {

    // ## TRACK INFO ## \\
    @State var text = ""
    @State var image: UIImage?
    @FocusState var focus: Bool

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager

    // ## SETUP VIEW ## \\
    var body: some View {
        NavigationStack {
            let my = DM.my()
        ScrollView {
        VStack(spacing: 16) {

            Upload2(scale: 0.75, image: $image)
            
        // ## CLICKABLES ## \\

        TextField("Write a short paragraph about your tastes.",
                  text: $text, axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .focused($focus)
            .lineLimit(4...8)
            .onTapGesture {
                focus = true
            }
        Max(count: 200, text: $text)

        Button("Save Edits") {
            if let image = image {
                DM.putImage(image: image, path: "profiles")
            }
            dismiss()
        }
        .buttonStyle(.borderedProminent)
        .disabled(image == nil || text.count > 200)
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
        }}}}}

struct Upload2: View {

    // ## TRACK INFO ## \\
    var scale: CGFloat
    @State var showCrop = false
    @Binding var image: UIImage?
    @State var imageItem: PhotosPickerItem?

    // ## SHOW IMAGE ## \\
    var body: some View {
        Group {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: UIheight * scale)
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
            .font(.subheadline)

        // ## UPLOAD PIC ## \\

        HStack {
            PhotosPicker("Photos \(Image(systemName: "photo"))",
                         selection: $imageItem, matching: .images)

            if image != nil {
                Button("\(Image(systemName: "crop"))") {
                    showCrop = true
        }}}
        .buttonStyle(.bordered)

        .onChange(of: imageItem) {_ in
            imageItem?.loadTransferable(type: Data.self) { res in

                switch res {
                case .success(let data):
                    image = UIImage(data: data ?? Data())
                case .failure(_):
                    return
                }}}}
        .fullScreenCover(isPresented: $showCrop) {
            ImageEditor(image: $image, show: $showCrop)
        }}}
