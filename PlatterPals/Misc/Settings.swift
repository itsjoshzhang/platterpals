import SwiftUI
import Firebase

struct Settings: View {

    // ## TRUE BOOLS ## \\
    @State var notifs = true
    @State var suggest = true
    @State var privacy = true
    @State var locate = true
    @State var showGuide = false

    // ## FALSE BOOLS ## \\
    @State var loggedOut = false
    @State var showReset = false
    @State var showTerms = false
    @State var showAlert = false
    @State var showDelete = false

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager

    // ## SETUP VIEW ## \\
    var body: some View {
        if loggedOut {
            Splash()
        } else {
            content
        }
    }
    // ## CHATS INFO ## \\

    var content: some View {
        NavigationStack {
        ZStack {
        Back()
        VStack(alignment: .leading, spacing: 16) {

        Group {
        HStack {
            Text("Chats")
                .font(.headline)
                .foregroundColor(.black)
            Spacer()
        }
        Div()
        HStack {
            Text("Allow chat notifications")
            Spacer()
            Toggle("", isOn: $notifs)
                .frame(width: 50)
        }
        Text("Blocked users: None")
        }
        // ## HOME SCREEN ## \\

        Group {
        Text("Home")
            .font(.headline)
            .foregroundColor(.black)
        Div()
        HStack {
            Text("Allow profile suggestions")
            Spacer()
            Toggle("", isOn: $suggest)
                .frame(width: 50)
        }
        HStack {
            Text("Allow location sharing")
            Spacer()
            Toggle("", isOn: $locate)
                .frame(width: 50)
        }
        }
        // ## SECURITY ## \\

        Group {
        Text("Security")
            .font(.headline)
            .foregroundColor(.black)
        Div()
        HStack {
            Text(DM.my().id)
                .font(.subheadline)
            Spacer()
            Button("Reset Login") {
                showReset = true
            }
            .buttonStyle(.bordered)
            .foregroundColor(.pink)
        }
        HStack {
            Text("Enable private profile")
            Spacer()
            Toggle("", isOn: $privacy)
                .frame(width: 50)
        }
        }
        // ## ACCOUNT INFO ## \\

        Group {
        Text("Account")
            .font(.headline)
            .foregroundColor(.black)
        Div()
        HStack {
            Button("How to use PlatterPals") {
                showGuide = true
            }
            .buttonStyle(.bordered)
            Spacer()
            Button("Terms and EULA") {
                showTerms = true
            }
        }
        if showDelete {
            HStack {
            Button("Cancel Deletion") {
                showDelete = false
            }
            .buttonStyle(.bordered)
            Spacer()
            Text("Deletion processing")
                .foregroundColor(.secondary)
            }
        } else {
            Button("Delete Account") {
                showAlert = true
                showDelete = true
            }
            .buttonStyle(.bordered)

        // ## MODIFIERS ## \\

        }}.foregroundColor(.pink)}
        .padding(.top, -80)
        .padding(16)

        .foregroundColor(.secondary)
        .navigationTitle("Settings")
        .onAppear {
            let sets = DM.settings
            notifs = sets.notifs
            suggest = sets.suggest
            privacy = sets.privacy
            locate = sets.locate
        }
        .sheet(isPresented: $showGuide) {
            Guide()
        }
        .sheet(isPresented: $showReset) {
            Reset()
        }
        .sheet(isPresented: $showTerms) {
            Terms()
        }
        .alert("Deletion may take up to 24 hours.", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        }
        // ## SAVE/SIGNOUT ## \\

        .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("\(Image(systemName: "chevron.left")) Save") {
                var sets = DM.settings

                sets.notifs = notifs
                sets.suggest = suggest
                sets.privacy = privacy
                sets.locate = locate

                DM.editSets(sets: sets)
                dismiss()
            }
        }
        ToolbarItem {
            let sn = "rectangle.portrait.and.arrow.right"
            Button("\(Image(systemName: sn))") {

                try? Auth.auth().signOut()
                withAnimation {
                    loggedOut = true
                }
            }
            .buttonStyle(.borderedProminent)
        }}}}}}
