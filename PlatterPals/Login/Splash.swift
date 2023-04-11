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

            if !first {
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

            if (DM.userList.count > 0 && DM.userList.count ==
                DM.userData.count) {
                withAnimation {
                    showNext = true
                }
            } else {
                internet = true
            }}}
        .toolbar {
            if first == false {
            ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") {
                dismiss()
            }}}}}}

struct Reset: View {

    // ## SETUP VIEW ## \\
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

            Text("We'll send you a reset link!")
        }
        .foregroundColor(.pink)

        // ## CLICKABLES ## \\

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
