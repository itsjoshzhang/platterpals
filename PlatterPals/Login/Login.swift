import SwiftUI
import Firebase

struct Login: View {

    @State var email = ""
    @State var pass = ""
    @State var text = ""
    @FocusState var focus: Bool

    @State var loading = true
    @State var loggedIn = false
    @State var showAlert = false
    @State var showReset = false
    @State var showSignup = false

    @EnvironmentObject var DM: DataManager
    @EnvironmentObject var MD: MapsData

    var body: some View {
        if loggedIn {
            MyTabView()
                .environmentObject(DM)
                .environmentObject(MD)
        } else {
            content
        }}
    var content: some View {
        VStack(spacing: 16) {

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
        }}

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

struct Reset: View {

    @State var email = ""
    @State var alertText = ""
    @State var showAlert = false
    @FocusState var focus: Bool
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
        VStack(spacing: 16) {

        Blank(label: "Email", text: $email)
            .focused($focus)
        Div()
        Text("We'll send you a reset link!")
            .foregroundColor(.secondary)

        Button("Reset Login") {
            resetLogin()
        }
        .disabled(email.isEmpty)
        .buttonStyle(.borderedProminent)

        .alert(alertText, isPresented: $showAlert) {
            Button("OK", role: .cancel) {
        }}}
        .padding(16)
        .navigationTitle("Reset Login")
        .background {
            Back()
        }
        .onAppear {
            focus = true
        }}}

    func resetLogin() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error != nil {
                alertText = "The email address is invalid."
                showAlert = true
            } else {
                dismiss()
            }}}}
