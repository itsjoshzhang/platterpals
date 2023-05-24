import SwiftUI
import Firebase

struct Login: View {

    // ## TEXTFIELDS ## \\
    @State var email = ""
    @State var password = ""
    @State var alertText = ""
    @FocusState var focus: Bool

    // ## CONDITIONS ## \\
    @State var loading = false
    @State var loggedIn = false
    @State var showAlert = false
    @State var showReset = false
    @State var showSignup = false

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
        Group {

        // ## TEXTFIELDS ## \\

        TextField("Email", text: $email)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .focused($focus)
        Div()

        SecureField("Password", text: $password)
            .focused($focus)
        Div()

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
        .buttonStyle(.borderedProminent)
        .disabled(email.isEmpty || password.isEmpty)

        .alert(alertText, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}}}
        .opacity(loading ? 1: 0)
        }
        .padding(16)
        }
        // ## MODIFIERS ## \\

        .onAppear {
            Auth.auth().addStateDidChangeListener {_,user in
            if let user = user {

                DM.initUser(id: user.email ?? email)
                withAnimation {
                    loggedIn = true
                }}}
            withAnimation {
                loading = true
            }
        }
        .sheet(isPresented: $showReset) {
            Reset()
        }
        .sheet(isPresented: $showSignup) {
            Signup()
                .environmentObject(DM)
        }
    }
    // ## FUNCTIONS ## \\

    func loginAuth() {
        Auth.auth().signIn(withEmail: email, password: password) {
            _,error in

            if let error = error {
                alertText = error.localizedDescription
                showAlert = true
            }}}}
