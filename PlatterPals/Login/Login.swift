import SwiftUI
import Firebase

struct Login: View {

    // ## TEXTFIELDS ## \\
    @State var email = ""
    @State var password = ""
    @State var alertText = ""
    @FocusState var focus: Bool

    // ## CONDITIONS ## \\
    @State var loggedIn = false
    @State var showAlert = false
    @State var showReset = false
    @State var showSignup = false

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager

    // ## OTHER VIEWS ## \\
    var body: some View {
        if loggedIn {
            MyTabView()
                .environmentObject(DM)
        } else {
            content
        }
    }
    var content: some View {
        ZStack {
            Back()
            VStack(spacing: 16) {

                // ## NAME & LOGO ## \\

                Text("PlatterPals")
                    .font(.custom("Lobster", size: 50))
                    .foregroundColor(.pink)
                    .padding(.bottom, 24)

                Image("logo")
                    .onTapGesture {
                        focus = false
                    }
                // ## TEXTFIELDS ## \\

                Group {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    Div()

                    SecureField("Password", text: $password)
                    Div()
                }
                .foregroundColor(.pink)
                .focused($focus)

                // ## CONDITIONS ## \\

                Button("Forgot your login?") {
                    showReset = true
                }
                Button("New to PlatterPals?") {
                    showSignup = true
                }
                .buttonStyle(.bordered)

                // ## LOGIN USER ## \\

                Button("Sign In") {
                    loginAuth()
                }
                .disabled(email == "" || password == "")
                .buttonStyle(.borderedProminent)

                .alert(alertText, isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                }
            }
            .padding(16)
        }
        // ## MODIFIERS ## \\

        .onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                if let user = user {
                    DM.initUser(id: user.email ?? email)
                    loggedIn = true
                }}}
        .sheet(isPresented: $showReset) {
            Reset()
                .presentationDetents([.medium])
        }
        .fullScreenCover(isPresented: $showSignup) {
            Signup()
                .environmentObject(DM)
        }
    }
    // ## FUNCTIONS ## \\

    func loginAuth() {
        Auth.auth().signIn(withEmail: email, password: password) {
            _, error in

            if let error = error {
                alertText = error.localizedDescription
                showAlert = true
            }
        }
    }
}
struct Reset: View {

    // ## TEXTFIELDS ## \\
    @State var email = ""
    @State var alertText = ""
    @State var showAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Back()
                VStack(spacing: 16) {

                    // ## TEXTFIELDS ## \\

                    Group {
                        TextField("Email", text: $email)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                        Div()

                        Text("We'll email you a reset link right away!")
                    }
                    .foregroundColor(.pink)

                    // ## BUTTONS ## \\

                    Button("Reset Password") {
                        resetPass()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(email == "")

                    .alert(alertText, isPresented: $showAlert) {
                        Button("OK", role: .cancel) {}
                    }
                }
                .navigationTitle("Reset Password")
                .padding(16)
            }}}

    // ## FUNCTIONS ## \\

    func resetPass() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                alertText = error.localizedDescription
                showAlert = true
            }}}}
