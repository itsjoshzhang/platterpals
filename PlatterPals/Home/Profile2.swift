import SwiftUI
import PhotosUI

struct ProfHead: View {

    // ## SETUP VIEW ## \\
    var id: String
    @State var showFollow = false
    @EnvironmentObject var DM: DataManager

    var body: some View {
        HStack {
        var data = DM.data(id: DM.my().id)
        HStack {

        // ## FOLLOWING ## \\

        if showFollow {
        Button("Following") {
            if let i = data.favUsers.firstIndex(of: id) {

                data.favUsers.remove(at: i)
                editData(data: data)
                showFollow = false
            }
        }
        .buttonStyle(.bordered)
        } else {
            Button("Follow \(Image(systemName: "heart"))") {

                data.favUsers.append(id)
                editData(data: data)
                showFollow = true
            }
            .buttonStyle(.borderedProminent)
            }
        }
    // ## FUNCTIONS ## \\

        .onAppear {
            showFollow = data.favUsers.contains(id)
        }}}
    func editData(data: UserData) {
        DM.editData(id: data.id, fo: data.favFoods, us:
            data.favUsers, ch: data.chatting, bl: data.blocked)
    }
}

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

    var body: some View {
        VStack(spacing: 16) {
        HStack(spacing: 16) {

            // ## SHOW IMAGE ## \\

            if let data = imageData {
                RoundPic(width: 160, image: UIImage(data: data))
            } else {
                RoundPic(width: 160, image: nil)
            }
        VStack(alignment: .leading, spacing: 16) {

            // ## UPLOAD IMAGE ## \\

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
        // ## USER INFO ## \\

        HStack(spacing: 0) {
            Text("Location:")
                .font(.headline)
                .foregroundColor(.pink)

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
        }
        }
        TextEditor(text: $text)
            .border(.secondary.opacity(0.25))

        // ## SAVE LOGIC ## \\

        if text.count > 200 {
            Text("200 chars max")
                .foregroundColor(.secondary)
        } else {
            Button("Save Edits") {
                DM.editUser(id: DM.my().id, name: name, text: text,
                            city: city, views: DM.my().views)

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
