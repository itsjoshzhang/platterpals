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
    @State var showAlert = false
    @State var showTerms = false
    @State var showGuide = false
    @State var imageData: Data?
    @FocusState var focus: Bool

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
            .padding(45)
        VStack(spacing: 16) {

        // ## SHOW IMAGE ## \\

        if let d = imageData, let image = UIImage(data: d) {
            RoundPic(width: 160, image: image)
        } else {
            RoundPic(width: 160, image: nil)

            Text("Crop to square for best result")
                .foregroundColor(.secondary)
        }
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
                ForEach(["Berkeley"], id: \.self) { city in
                    Text(city)
                }
            }
            .buttonStyle(.bordered)
        }
        HStack(spacing: 4) {
            Text("I agree to the")
                .foregroundColor(.secondary)

            Button("terms and EULA") {
                showTerms = true
            }
        }
        Group {
            Button("How to use PlatterPals") {
                showGuide = true
            }
        // ## CREATE USER ## \\

        Button("Sign Up") {
            signupAuth()
        }
        .disabled(name.isEmpty)
        .alert(alertText, isPresented: $showAlert) {
            Button("OK", role: .cancel) {
        }}}
        .buttonStyle(.borderedProminent)
        }
        .padding(16)
        Spacer().padding(85)

        .navigationTitle("Sign Up")
        .onTapGesture {
            focus = false
        }
        .sheet(isPresented: $showGuide) {
            Guide()
        }
        .sheet(isPresented: $showTerms) {
            Terms()
        }}}}}

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

                if let d = imageData, let image = UIImage(data: d) {
                    DM.putImage(image: image, path: "avatars")
                }
                dismiss()
            }}}}
