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
    @State var page = 0
    @State var name = ""
    @State var text = ""
    @State var city = "Berkeley"
    @State var showCrop = false

    // ## SETUP VIEW ## \\
    @State var image: UIImage?
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
            Cities(addAll: false, city: $city, page: $page)
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
            if (page != 2 && !city.hasSuffix("CA")) {
                city += ", CA"
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
            if cityList.contains(t(my.city)) {
                city = t(my.city)
            } else if allCities.contains(t(my.city)) {
                page = 1
                city = t(my.city)
            } else {
                page = 2
                city = ""
            }
        }
        .fullScreenCover(isPresented: $showCrop) {
            ImageEditor(image: $image, show: $showCrop)
        }
    }
    // ## FUNCTIONS ## \\

    func count(_ text: String) -> Bool {
        return (text.trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty || text.count > 32)
    }
    func t(_ text: String) -> String {
        return text.trimmingCharacters(in:
            CharacterSet(charactersIn: ", CA"))
    }
}
