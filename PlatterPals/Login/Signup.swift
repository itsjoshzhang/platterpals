import SwiftUI
import PhotosUI
import Firebase

struct Signup: View {

    // ## TEXTFIELDS ## \\
    @State var name = ""
    @State var email = ""
    @State var password = ""
    @State var alertText = ""
    @State var city = "Berkeley"

    // ## CONDITIONS ## \\
    @FocusState var focus: Bool
    @State var showCrop = false
    @State var showAlert = false
    @State var showTerms = false
    @State var showGuide = false

    // ## IMAGE VARS ## \\
    @State var image: UIImage?
    @State var imageItem: PhotosPickerItem?

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager

    // ## SETUP VIEW ## \\
    var body: some View {
        NavigationStack {
        ZStack {
        Back()
        ScrollView {
        Spacer()
            .padding(40)
        VStack(spacing: 16) {

        // ## SHOW IMAGE ## \\

        if let image = image {
            RoundPic(width: 160, image: image)
        } else {
            RoundPic(width: 160, image: nil)

            Text("Crop to square for best result")
                .foregroundColor(.secondary)
                .font(.subheadline)
        }
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
                }}}

        // ## TEXTFIELDS ## \\

        Group {
            TextField("Email", text: $email)
            Div()

            SecureField("Password", text: $password)
            Div()

            TextField("Username", text: $name)
            Div()
        }
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
        .focused($focus)
        .onTapGesture {
            focus = true
        }
        // ## USER INFO ## \\

        HStack {
            Text("Location:")
                .font(.headline)

            Picker("", selection: $city) {
                ForEach(cityList, id: \.self) {
                    Text($0)
                }
            }
            .buttonStyle(.bordered)
        }
        HStack(spacing: 0) {
            Text("I agree to the ")
                .foregroundColor(.secondary)

            Button("terms and EULA") {
                showTerms = true
            }
        }
        Button("How to use PlatterPals") {
            showGuide = true
        }
        .buttonStyle(.bordered)

        // ## CREATE USER ## \\

        Button("Sign Up") {
            signupAuth()
        }
        .disabled(name.isEmpty)
        .buttonStyle(.borderedProminent)

        .alert(alertText, isPresented: $showAlert) {
            Button("OK", role: .cancel) {
        }}}
        .padding(16)
        .navigationTitle("Sign Up")
        .onTapGesture {
            focus = false
        }
        .fullScreenCover(isPresented: $showCrop) {
            ImageEditor(image: $image, show: $showCrop)
        }
        .sheet(isPresented: $showGuide) {
            Guide()
        }
        .sheet(isPresented: $showTerms) {
            Terms()
        }
        Spacer()
            .padding(85)
        }}}}

    // ## FUNCTIONS ## \\

    func signupAuth() {
        Auth.auth().createUser(withEmail: email, password: password) {
            _,error in

            if let error = error {
                alertText = error.localizedDescription
                showAlert = true
            } else {
                DM.makeUser(id: email, name: name, city: city)
                DM.initUser(id: email)

                if let image = image {
                    DM.putImage(image: image, path: "avatars")
                }
                dismiss()
            }}}}
