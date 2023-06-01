import SwiftUI
import PhotosUI
import Firebase

struct Signup: View {

    // ## TEXTFIELDS ## \\
    @State var email = ""
    @State var pass = ""
    @State var name = ""
    @State var alertText = ""
    @State var city = "Berkeley"

    // ## CONDITIONS ## \\
    @FocusState var focus: Bool
    @State var showCrop = false
    @State var showAlert = false
    @State var showTerms = false
    @State var showGuide = false

    // ## SETUP VIEW ## \\
    @State var page = 0
    @State var image: UIImage?
    @State var imageItem: PhotosPickerItem?

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager

    var body: some View {
        NavigationStack {
        VStack(spacing: 16) {

        // ## SHOW IMAGE ## \\

        RoundPic(width: 160, image: image)
            .padding(.top, -120)

        Text("Crop to square for best result")
            .foregroundColor(.secondary)
            .font(.subheadline)

        HStack {
            PhotosPicker("Photos \(Image(systemName: "photo"))",
                         selection: $imageItem, matching: .images)

            if image != nil {
                Button("\(Image(systemName: "crop"))") {
                    showCrop = true
        }}}
        .buttonStyle(.bordered)

        // ## OTHER LOGIC ## \\

        .onChange(of: imageItem) {_ in
            imageItem?.loadTransferable(type: Data.self) { result in

                switch result {
                case .success(let data):
                    image = UIImage(data: data ?? Data())
                case .failure(_):
                    return
                }}}

        Group {
            Blank(label: "Email", text: $email)
        Div()
            Blank(label: "Password", secure: true, text: $pass)
        Div()
            Blank(label: "Username", text: $name)
        Div()
        }
        .focused($focus)
        .onTapGesture {
            focus = true
        }
        // ## USER INFO ## \\

        HStack(spacing: 0) {
            Text("Nearest City: ")
                .font(.headline)

            Cities(addAll: false, city: $city, page: $page)
                .buttonStyle(.bordered)
        }
        .frame(width: UIwidth * 0.8)

        HStack(spacing: 0) {
            Text("I agree to the ")
                .foregroundColor(.secondary)
            Button("terms and EULA") {
                showTerms = true
            }
        }
        Button("Sign Up") {
            if page != 2 {
                city += ", CA"
            }
            signupAuth()
            dismiss()
        }
        .disabled(email.isEmpty || pass.isEmpty
                 || count(name) || count(city))
        .buttonStyle(.borderedProminent)

        // ## MODIFIERS ## \\

        .alert(alertText, isPresented: $showAlert) {
            Button("OK", role: .cancel) {
        }}}
        .padding(16)
        .navigationTitle("Sign Up")
        .background {
            Back()
        }
        .onTapGesture {
            focus = false
        }
        .fullScreenCover(isPresented: $showCrop) {
            ImageEditor(image: $image, show: $showCrop)
        }
        .sheet(isPresented: $showTerms) {
            Terms()
        }}}

    // ## FUNCTIONS ## \\

    func signupAuth() {
    Auth.auth().createUser(withEmail: email, password: pass) {_,e in

        if let e = e {
            alertText = e.localizedDescription
            showAlert = true
        } else {
            DM.makeUser(id: email, name: name, city: city)
            DM.initUser(id: email)
            if let image = image {
                DM.putImage(image: image, path: "avatars")
            }}}}

    func count(_ text: String) -> Bool {
        return (text.trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty || text.count > 32)
    }
}
