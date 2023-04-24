import SwiftUI
import Firebase

struct Settings: View {

    // ## TRUE BOOLS ## \\
    @State var notifs = true
    @State var suggest = true
    @State var privacy = true
    @State var location = true

    // ## FALSE BOOLS ## \\
    @State var delete = false
    @State var loggedOut = false
    @State var showReset = false
    @State var showTerms = false
    @State var showDelete = false

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager

    // ## SETUP VIEW ## \\

    var body: some View {
        if loggedOut {
            Splash(first: true)
        } else {
            content
        }
    }
    var content: some View {
        NavigationStack {
        ZStack {
        Back()
        VStack {
        VStack(alignment: .leading, spacing: 16) {

        // ## CHATS INFO ## \\

        Group {
        HStack {
            Text("Chats")
                .font(.headline)
            Spacer()
        }
        Div()
        HStack {
            Text("Allow chat notifications")
                .foregroundColor(.secondary)
            Spacer()
            Toggle("", isOn: $notifs)
                .frame(width: 50)
        }
        Text("Blocked users: None")
            .foregroundColor(.secondary)
        }
        // ## HOME SCREEN ## \\

        Group {
        Text("Home")
            .font(.headline)
        Div()
        HStack {
            Text("Allow profile suggestions")
                .foregroundColor(.secondary)
            Spacer()
            Toggle("", isOn: $suggest)
                .frame(width: 50)
        }
        HStack {
            Text("Allow location sharing")
                .foregroundColor(.secondary)
            Spacer()
            Toggle("", isOn: $location)
                .frame(width: 50)
        }
        }
        // ## ORDER INFO ## \\

        Group {
        Text("Orders")
            .font(.headline)
        Div()
        Text("Order history: None")
            .foregroundColor(.secondary)
        Text("Favorite foods: None")
            .foregroundColor(.secondary)
        }
        // ## SECURITY ## \\

        Group {
        Text("Security")
            .font(.headline)
        Div()
        HStack {
            Text(DM.my().id)
                .foregroundColor(.secondary)
                .font(.subheadline)
            Spacer()
            Button("Reset Password") {
                showReset = true
            }
            .buttonStyle(.bordered)
        }
        HStack {
            Text("Enable private profile")
                .foregroundColor(.secondary)
            Spacer()
            Toggle("", isOn: $privacy)
                .frame(width: 50)
        }
        }
        // ## ACCOUNT? ## \\

        Group {
        Text("Account")
            .font(.headline)
        Div()
        Button("Terms and EULA") {
            showTerms = true
        }
        if delete {
            HStack {
            Button("Cancel Deletion") {
                showDelete = false
                delete = false
            }
            .buttonStyle(.bordered)
            Spacer()
            Text("Deletion processing")
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
        } else {
            Button("Delete Account") {
                showDelete = true
                delete = true
            }
            .buttonStyle(.bordered)
        }}}

        // ## MODIFIERS ## \\

        .padding(.horizontal, 16)
        .onAppear {
            let sets = DM.settings
            notifs = sets.notifs
            suggest = sets.suggest
            privacy = sets.privacy
            location = sets.location
        }
        .sheet(isPresented: $showReset) {
            Reset()
        }
        .sheet(isPresented: $showTerms) {
            Terms()
        }
        .alert(isPresented: $showDelete) {
            Alert(title: Text("Delete account"),
              message: Text("Deletion may take up to 24 hours."),
              dismissButton: .default(Text("Continue")))
        }
        // ## SAVE/SIGNOUT ## \\

        .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("\(Image(systemName: "chevron.left")) Save") {
                var sets = DM.settings

                sets.notifs = notifs
                sets.suggest = suggest
                sets.privacy = privacy
                sets.location = location
                DM.editSets(sets: sets)
                dismiss()
            }
        }
        ToolbarItem {
            let signout = "rectangle.portrait.and.arrow.right"
            Button("\(Image(systemName: signout))") {

                try? Auth.auth().signOut()
                withAnimation {
                    loggedOut = true
                }
            }
            .buttonStyle(.borderedProminent)
        }}}}}}}
