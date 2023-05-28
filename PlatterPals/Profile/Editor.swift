import SwiftUI
import PhotosUI

struct ProfHead: View {

    // ## SETUP VIEW ## \\
    var id: String
    @State var showFollow = false
    @EnvironmentObject var DM: DataManager

    var body: some View {
        HStack {
        var data = DM.md()
        HStack {

        // ## UNFOLLOW ## \\

        if showFollow {
        Button("Following") {
            if let i = data.favUsers.firstIndex(of: id) {
                data.favUsers.remove(at: i)
                DM.editData(data: data)
                showFollow = false
            }
        }
        .buttonStyle(.bordered)

        // ## REFOLLOW ## \\

        } else {
            Button("Follow ♥") {
                data.favUsers.append(id)
                DM.editData(data: data)
                showFollow = true
            }
            .buttonStyle(.borderedProminent)
            }
        }
        .onAppear {
            showFollow = data.favUsers.contains(id)
        }}}}

struct EditProf: View {

    // ## TRACK INFO ## \\
    @State var name = ""
    @State var text = ""
    @State var city = "Berkeley"
    @State var showCrop = false
    @State var image: UIImage?

    // ## SETUP VIEW ## \\
    @State var imageItem: PhotosPickerItem?

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager

    // ## USER INFO ## \\

    var body: some View {
        var my = DM.my()
        VStack(spacing: 16) {
        HStack(spacing: 16) {

        RoundPic(width: 120, image: image)

        VStack(alignment: .leading, spacing: 8) {

        Blank(label: "Username", text: $name)
            .textFieldStyle(.roundedBorder)

        HStack(spacing: 0) {
            Text("City: ")
                .font(.headline)
            Cities(addAll: false, city: $city)
        }
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
                }}}}}

        // ## CLICKABLES ## \\

        TextField("Write a short paragraph about your tastes.",
                  text: $text, axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .submitLabel(.done)
            .lineLimit(4...8)

        Max(count: 200, text: $text)

        Button("Save Edits") {
            if let image = image {
                DM.putImage(image: image, path: "avatars")
            }
            my.name = name
            my.text = text
            my.city = city

            DM.editUser(user: my)
            dismiss()
        }
        // ## MODIFIERS ## \\

        .disabled(text.count > 200 || count(name) || count(city))
        .buttonStyle(.borderedProminent)
        }
        .padding(16)
        .onAppear {
            name = my.name
            text = my.text
            image = DM.myAvatar
        }
        .onChange(of: DM.myAvatar) {_ in
            image = DM.myAvatar
        }
        .fullScreenCover(isPresented: $showCrop) {
            ImageEditor(image: $image, show: $showCrop)
        }
    }
    func count(_ text: String) -> Bool {
        return (text.trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty || text.count > 32)
    }
}
