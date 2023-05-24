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
    @State var showSets = false
    @State var showCrop = false

    // ## IMAGE VARS ## \\
    @State var image: UIImage?
    @State var imageItem: PhotosPickerItem?
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager

    // ## SHOW IMAGE ## \\

    var body: some View {
        VStack(spacing: 16) {
        var my = DM.my()
        HStack(spacing: 16) {

        if let image = image {
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
                ForEach(cityList, id: \.self) {
                    Text($0)
                }
            }
            .frame(maxWidth: UIwidth, alignment: .leading)
        }
        // ## UPLOAD PIC ## \\

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
                }}}}}

        TextEditor(text: $text)
            .border(UIgray)

        // ## SAVE LOGIC ## \\

        if (text.count > 200) {
            Text("200 chars max")
                .foregroundColor(.secondary)
        } else {
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
            .disabled(name.isEmpty || text.isEmpty)
            .buttonStyle(.borderedProminent)

            .onAppear {
                name = my.name
                text = my.text
            }}}
        .padding(16)
        .fullScreenCover(isPresented: $showCrop) {
            ImageEditor(image: $image, show: $showCrop)
        }
    }
}
