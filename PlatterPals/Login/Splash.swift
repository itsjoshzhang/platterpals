import SwiftUI
import Firebase

struct Splash: View {

    @State var scale = 0.9
    @State var opacity = 0.0
    @State var update = false
    @State var showNext = false

    @StateObject var DM = DataManager()
    @StateObject var MD = MapsData()

    var body: some View {
        if showNext {
            Login()
                .environmentObject(DM)
                .environmentObject(MD)
        } else {
            content }}
    var content: some View {
        ZStack {
        Back()
        VStack(spacing: 16) {

        Image("logo")
            .resizable()
            .scaledToFit()
            .frame(width: UIwidth-32)

        Text("PlatterPals")
            .font(.custom("Lobster", size: 50))

        if update {
            Text("An update to PlatterPals is here!")
                .font(.headline)

            HStack(spacing: 0) {
            Text("Download now from the ")
                .foregroundColor(.secondary)

            Link(destination: URL(string:
                "https://apps.apple.com/app/id1667418651")!) {
                Text("App Store.")

        }}} else {
            ProgressView()
                .scaleEffect(2)
                .tint(.pink)
                .padding(16)
        }}}
        .foregroundColor(.pink)
        .scaleEffect(scale)
        .opacity(opacity)
        .onAppear {
            withAnimation {
                scale = 1.0
                opacity = 1.0
            }
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            if DM.version == VERSION {
                withAnimation {
                    showNext = true
                }
            } else {
                withAnimation {
                    update = true
                }}}}}}

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
