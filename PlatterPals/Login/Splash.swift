import SwiftUI
import Firebase

struct Splash: View {

    // ## TRACK INFO ## \\
    @State var first: Bool
    @State var scale = 0.9
    @State var opacity = 0.0
    @State var showNext = false
    @State var internet = false

    @Environment(\.dismiss) var dismiss
    @StateObject var DM = DataManager()

    // ## OTHER VIEWS ## \\

    var body: some View {
        if showNext {
            if first {
                Login().environmentObject(DM)
            } else {
                Order().environmentObject(DM)
        }} else {
            content
        }}
    var content: some View {
        ZStack {
        Back()

        // ## LOGO & TEXT ## \\

        VStack(spacing: 16) {
        Image("logo")

        Text("PlatterPals")
            .font(.custom("Lobster", size: 50))

        if first == false {
            Text("Finding the perfect dish...")
                .font(.headline)
        }
        if internet {
            Text("Poor internet. Refresh App.")
                .font(.headline)
        }
        ProgressView()
            .scaleEffect(2)
            .tint(.pink)
            .padding(16)
        }
        .foregroundColor(.pink)
        }
        .scaleEffect(scale)
        .opacity(opacity)

        // ## MODIFIERS ## \\

        .onAppear {
            withAnimation {
                scale = 1.0
                opacity = 1.0
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let list = DM.userList.count

            if (list > 0 && list == DM.userData.count) {
                withAnimation {
                    showNext = true
                }
            } else {
                withAnimation {
                    internet = true
                }}}}}}

struct Reset: View {

    // ## SETUP VIEW ## \\
    @State var email = ""
    @State var alertText = ""
    @State var showAlert = false
    @FocusState var focus: Bool
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
        ZStack {
        Back()
        VStack(spacing: 16) {

        // ## TEXTFIELDS ## \\
            
        TextField("Email", text: $email)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .focused($focus)
        Div()

        Text("We'll send you a reset link!")
            .foregroundColor(.secondary)

        Button("Reset Password") {
            resetPass()
        }
        .disabled(email == "")
        .buttonStyle(.borderedProminent)

        .alert(alertText, isPresented: $showAlert) {
            Button("OK", role: .cancel) {
        }}}

        // ## FUNCTIONS ## \\

        .navigationTitle("Reset Password")
        .padding(16)
        .onAppear {
            focus = true
        }}}}

    func resetPass() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                alertText = error.localizedDescription
                showAlert = true
            } else {
                dismiss()
            }}}}
