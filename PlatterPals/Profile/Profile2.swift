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
        var my = DM.my()
        HStack(spacing: 16) {

        if let d = imageData, let image = UIImage(data: d) {
            RoundPic(width: 120, image: image)
        } else {
            RoundPic(width: 120, image: nil)
        }
        // ## USER INFO ## \\

        VStack(alignment: .leading, spacing: 8) {

        TextField("Username", text: $name)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .font(.headline)

        HStack(spacing: 0) {
            Text("Location:")
                .font(.headline)

            Picker("", selection: $city) {
                ForEach(["Berkeley"], id: \.self) { city in
                    Text(city)
                }
            }
            .frame(maxWidth: UIwidth, alignment: .leading)
        }
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
                }}}}}

        TextEditor(text: $text)
            .border(UIgray)

        // ## SAVE LOGIC ## \\

        if (text.count > 200) {
            Text("200 chars max")
                .foregroundColor(.secondary)
        } else {
            Button("Save Edits") {
                if let d = imageData, let image = UIImage(data: d) {
                    DM.putImage(image: image, path: "avatars")
                }
                my.name = name
                my.text = text
                my.city = city

                DM.editUser(user: my)
                dismiss()
            }
            .disabled(name.isEmpty || text.isEmpty)
            .buttonStyle(.borderedProminent)

            .onAppear {
                name = my.name
                text = my.text
            }}}
        .padding(16)
    }
}
