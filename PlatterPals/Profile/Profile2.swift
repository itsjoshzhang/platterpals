import SwiftUI
import PhotosUI

struct ProfHead: View {

    // ## SETUP VIEW ## \\
    var id: String
    @State var showFollow = false
    @EnvironmentObject var DM: DataManager

    var body: some View {
        HStack {
            var favs = DM.md().favUsers
            var user = DM.user(id: id)
        HStack {

        // ## CLICKABLES ## \\

        if showFollow {
        Button("Following") {
            if let i = favs.firstIndex(of: id) {

                favs.remove(at: i)
                DM.editData()
                user.views -= 1
                DM.editUser(user: user)
                showFollow = false
            }
        }
        .buttonStyle(.bordered)
        } else {
            Button("Follow \(Image(systemName: "heart"))") {

                favs.append(id)
                DM.editData()
                user.views += 1
                DM.editUser(user: user)
                showFollow = true
            }
            .buttonStyle(.borderedProminent)
            }
        }
        .onAppear {
            showFollow = favs.contains(id)
        }}}}

struct EditProf: View {

    // ## TRACK INFO ## \\
    @State var name = ""
    @State var text = ""
    @State var city = "Berkeley"
    @State var image: UIImage?

    // ## CONDITIONS ## \\
    @State var showSets = false
    @State var imageData: Data?
    @State var imageItem: PhotosPickerItem?
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var DM: DataManager

    // ## SHOW IMAGE ## \\

    var body: some View {
        VStack(spacing: 16) {
        HStack(spacing: 16) {

        if let d = imageData, let image = UIImage(data: d) {
            RoundPic(width: 160, image: image)
        } else {
            RoundPic(width: 160, image: nil)
        }
        VStack(alignment: .leading, spacing: 16) {

        // ## UPLOAD PIC ## \\

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
                }}}

        // ## USER INFO ## \\

        HStack(spacing: 0) {
            Text("Location:")
                .foregroundColor(.pink)
                .font(.headline)

            Picker("", selection: $city) {
                ForEach(["Berkeley"], id: \.self) { city in
                    Text(city)
                }
            }
            .buttonStyle(.bordered)
            .frame(maxWidth: UIwidth)
        }
        TextField("Username", text: $name)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .font(.headline)
        }
        }
        TextEditor(text: $text)
            .border(gray)

        // ## SAVE LOGIC ## \\

        if text.count > 200 {
            Text("200 chars max")
                .foregroundColor(.secondary)
        } else {
            Button("Save Edits") {

                var user = DM.my()
                user.name = name
                user.text = text
                user.city = city
                DM.editUser(user: user)

                if let d = imageData, let image = UIImage(data: d) {
                    DM.putImage(image: image, path: "avatars")
                }
                dismiss()
            }
            .disabled(name == "" || text == "")
            .buttonStyle(.borderedProminent)
        }
        }
        .padding(16)
        .onAppear {
            name = DM.my().name
            text = DM.my().text
        }
    }
}
