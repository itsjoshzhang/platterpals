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
        VStack(spacing: 16) {
        Spacer()
            .padding(32)

        // ## SHOW IMAGE ## \\

        if let d = imageData, let image = UIImage(data: d) {
            RoundPic(width: 160, image: image)
        } else {
            RoundPic(width: 160, image: nil)
        }
        PhotosPicker("Upload Picture", selection: $imageItem,
                     matching: .images)
        .buttonStyle(.bordered)

        // ## UPLOAD PIC ## \\

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
        // ## LOCATIONS ## \\

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
        // ## TERMS GUIDE ## \\

        HStack {
            Text("I agree to the")
                .foregroundColor(.secondary)

            Button("terms and EULA") {
                showTerms = true
            }
        }
        Group {
            Button("PlatterPals How-To") {
                showGuide = true
            }
        // ## CREATE USER ## \\

            Button("Sign Up") {
                signupAuth()
            }
            .disabled(name == "")
            .padding(.bottom, 32)

            .alert(alertText, isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            }
        }
        .buttonStyle(.borderedProminent)
        }
        .padding(16)
        }
        }
        // ## MODIFIERS ## \\

        .navigationTitle("Create Account")
        .onTapGesture {
            focus = false
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }}}
        .sheet(isPresented: $showGuide) {
            Guide()
        }
        .sheet(isPresented: $showTerms) {
            Terms()
        }}}

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
