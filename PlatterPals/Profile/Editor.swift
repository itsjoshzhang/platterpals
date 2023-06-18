import SwiftUI
import PhotosUI

struct ProfHead: View {

    var id: String
    @State var showFollow = false
    @EnvironmentObject var DM: DataManager

    var body: some View {
        HStack {
        var data = DM.md()
        HStack {

        if showFollow {
        Button("Following") {
            if let i = data.favUsers.firstIndex(of: id) {
                data.favUsers.remove(at: i)
                DM.editData(data: data)
                showFollow = false
            }
        }
        .buttonStyle(.bordered)
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

    @State var name = ""
    @State var text = ""
    @State var city = "Berkeley"
    @State var showCrop = false
    @State var rest = false

    @FocusState var focus0: Bool
    @FocusState var focus1: Bool
    @FocusState var focus2: Bool
    @State var image: UIImage?
    @State var imageItem: PhotosPickerItem?

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager

    var body: some View {
        var my = DM.my()
        VStack(spacing: 16) {
        HStack(spacing: 16) {

        RoundPic(width: 120, image: image)

        VStack(alignment: .leading, spacing: 8) {

        Blank(label: "Username", text: $name)
            .textFieldStyle(.roundedBorder)
            .focused($focus0)
            .onTapGesture {
                focus0 = true
            }
        HStack {
        Text("City:")
            .font(.headline)
        City(city: $city)
            .focused($focus1)
            .onTapGesture {
                focus1 = true
            }
        }
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

        TextField("Write a short paragraph about your tastes.",
                  text: $text, axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .lineLimit(4...8)
            .focused($focus2)
            .onTapGesture {
                focus2 = true
            }
        Max(count: 200, text: $text)

        HStack {
        Toggle("I'm a restaurant", isOn: $rest)
            .toggleStyle(.button)
            .overlay(RoundedRectangle(
                cornerRadius: 8).stroke(.pink))
        Spacer()

        Button("Save Edits") {
            if let image = image {
                DM.putImage(image: image, path: "avatars")
            }
            my.name = name; my.text = text; my.city = city; my.rest = rest
            DM.editUser(user: my)
            focus0 = false; focus1 = false; focus2 = false; dismiss()
        }
        .disabled(text.count > 200 || count(name) || count(city))
        .buttonStyle(.borderedProminent)
        }
        }
        .padding(16)
        .onTapGesture {
            focus0 = false; focus1 = false; focus2 = false
        }
        .onAppear {
            name = my.name; text = my.text; city = my.city; rest = my.rest
            image = DM.myAvatar
        }
        .fullScreenCover(isPresented: $showCrop) {
            ImageEditor(image: $image, show: $showCrop)
        }}}
