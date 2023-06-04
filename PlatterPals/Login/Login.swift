import SwiftUI
import Firebase

struct Login: View {

    // ## TEXTFIELDS ## \\
    @State var email = ""
    @State var pass = ""
    @State var text = ""
    @FocusState var focus: Bool

    // ## CONDITIONS ## \\
    @State var loading = true
    @State var loggedIn = false
    @State var showAlert = false
    @State var showReset = false
    @State var showSignup = false

    @EnvironmentObject var DM: DataManager
    @EnvironmentObject var MD: MapsData

    // ## OTHER VIEWS ## \\
    var body: some View {
        if loggedIn {
            MyTabView()
                .environmentObject(DM)
                .environmentObject(MD)
        } else {
            content
        }
    }
    // ## NAME & LOGO ## \\

    var content: some View {
        VStack(spacing: 16) {

        // ## SHOW CONTENT ## \\

        Text("PlatterPals")
            .font(.custom("Lobster", size: 50))
            .foregroundColor(.pink)
            .padding(.bottom, 24)

            Image("logo")
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    focus = false
                }
        Group {
        Group {
            Blank(label: "Email", text: $email)
            Div()
            Blank(label: "Password", secure: true, text: $pass)
            Div()
        }
        .focused($focus)

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
        .disabled(email.isEmpty || pass.isEmpty)
        }
        .opacity(loading ? 0: 1)
        .onAppear {
            Auth.auth().addStateDidChangeListener {_,user in
                if let user = user {
                    DM.initUser(id: user.email ?? email)
                    withAnimation {
                        loggedIn = true
                    }}}
            withAnimation(.easeIn(duration: 1)) {
                loading = false
            }}}

        // ## MODIFIERS ## \\

        .padding(16)
        .background {
            Back()
        }
        .alert(text, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        }
        .sheet(isPresented: $showReset) {
            Reset()
        }
        .fullScreenCover(isPresented: $showSignup) {
            Signup()
                .environmentObject(DM)
        }
    }
    // ## FUNCTIONS ## \\

    func loginAuth() {
        Auth.auth().signIn(withEmail: email, password: pass) {_,e in
            if let e = e {
                text = e.localizedDescription

                if text.hasSuffix("ed.") {
                    text = "The email address is invalid."
                } else if text.hasSuffix("rd.") {
                    text = "The given password is invalid."
                }
                showAlert = true
            }}}}
