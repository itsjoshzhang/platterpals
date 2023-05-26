import SwiftUI
import Firebase

struct Splash: View {

    // ## TRACK INFO ## \\
    @State var scale = 0.9
    @State var opacity = 0.0
    @State var showNext = false
    @State var internet = false

    @Environment(\.dismiss) var dismiss
    @StateObject var DM = DataManager()

    // ## SETUP VIEW ## \\

    var body: some View {
        if showNext {
            Login()
                .environmentObject(DM)
        } else {
            content
        }
    }
    var content: some View {

        // ## LOGO & TEXT ## \\

        VStack(spacing: 16) {
        Image("logo")

        Text("PlatterPals")
            .font(.custom("Lobster", size: 50))

        if internet {
            Text("Poor internet. Please refresh app.")
                .font(.headline)
        }
        ProgressView()
            .scaleEffect(2)
            .tint(.pink)
            .padding(16)
        }
        .foregroundColor(.pink)
        .scaleEffect(scale)
        .opacity(opacity)
        .background {
            Back()
        }
        // ## MODIFIERS ## \\

        .onAppear {
            withAnimation {
                scale = 1.0
                opacity = 1.0
            }
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {

            // MARK: - TODO: - FIXME
            if (DM.userData.count > 0) {
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
        VStack(spacing: 16) {

        // ## TEXTFIELDS ## \\
            
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

        // ## FUNCTIONS ## \\

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
            if let error = error {
                alertText = error.localizedDescription
                showAlert = true
            } else {
                dismiss()
            }}}}
