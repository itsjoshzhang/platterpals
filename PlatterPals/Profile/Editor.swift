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
    @FocusState var focus: Bool

    // ## SETUP VIEW ## \\
    @State var image: UIImage?
    @State var imageItem: PhotosPickerItem?
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var DM: DataManager

    var body: some View {
        NavigationStack {

        VStack(spacing: 16) {
            var my = DM.my()
        HStack(spacing: 16) {

        // ## USER INFO ## \\

        if let image = image {
            RoundPic(width: 120, image: image)
        } else {
            RoundPic(width: 120, image: nil)
        }
        VStack(alignment: .leading, spacing: 8) {

        Blank(label: "Username", text: $name)
            .textFieldStyle(.roundedBorder)
            .focused($focus)
            .onTapGesture {
                focus = true
            }
        HStack(spacing: 0) {
            Text("City: ")
                .font(.headline)
            Cities(addAll: false, city: $city)
                .buttonStyle(.bordered)
        }
        // ## UPLOAD PIC ## \\

        HStack {
            PhotosPicker("Pick Photo", selection: $imageItem,
                         matching: .images)

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

        TextField("Add a bio", text: $text, axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .focused($focus)
            .lineLimit(8)
            .onTapGesture {
                focus = true
            }
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

        .disabled(name.isEmpty || city.isEmpty)
        .buttonStyle(.borderedProminent)
        .onAppear {
            name = my.name
            text = my.text
        }
        Spacer()
        }
        .padding(16)
        .navigationTitle("Edit Profile")
        .background {
            Back()
        }
        .fullScreenCover(isPresented: $showCrop) {
            ImageEditor(image: $image, show: $showCrop)
        }}}
    
    func count(_ text: String) -> Bool {
        return (text.isEmpty || text.count > 32)
    }
}
