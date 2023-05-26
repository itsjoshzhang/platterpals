import SwiftUI
import Firebase

struct Settings: View {

    // ## TRUE BOOLS ## \\
    @State var notifs = true
    @State var suggest = true
    @State var privacy = true
    @State var locate = true
    @State var guide = false

    // ## FALSE BOOLS ## \\
    @State var loggedOut = false
    @State var showReset = false
    @State var showTerms = false
    @State var showAlert = false
    @State var showDelete = false

    // ## SETUP VIEW ## \\

    @State var blockID = "..."
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager

    var body: some View {
        if loggedOut {
            Splash()
        } else {
            content
        }
    }
    var content: some View {
        NavigationStack {
            var data = DM.md()
            let myID = DM.my().id
        VStack(alignment: .leading, spacing: 16) {

        // ## CHATS INFO ## \\

        Group {
        Text("Chats")
            .font(.headline)
            .foregroundColor(.black)
        Div()
        HStack {
            Text("Allow chat notifications")
            Spacer()
            Toggle("", isOn: $notifs)
                .frame(width: 50)
        }
        HStack(spacing: 0) {
            Text("Blocked: ")
            Picker("", selection: $blockID) {
                ForEach(["..."] + data.blocked, id: \.self) { id in
                    Text(id == "..." ? id: DM.user(id: id).name)
                }
            }
            Spacer()
            Button("Unblock") {
                if let i = data.blocked.firstIndex(of: blockID) {
                    data.blocked.remove(at: i)
                    DM.editData(data: data)
                    blockID = "..."
                }
            }
            .disabled(blockID == "...")
            .buttonStyle(.bordered)
            .foregroundColor(.none)
        }
        }
        // ## PROFILE INFO ## \\

        Group {
        Text("Profiles")
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
            Text(myID)
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
                DM.sendFlag(id: myID, type: "delete")
                showAlert = true
                showDelete = true
            }
            .buttonStyle(.bordered)
        }
        Button("Terms and EULA") {
            showTerms = true
        }
        .padding(.bottom, 80)
        }
        // ## MODIFIERS ## \\

        .foregroundColor(.pink)
        }
        .padding(16)
        .foregroundColor(.secondary)
        .navigationTitle("Settings")
        .background {
            Back()
        }
        .onAppear {
            let sets = DM.settings
            notifs = sets.notifs
            suggest = sets.suggest
            privacy = sets.privacy
            locate = sets.locate
        }
        .sheet(isPresented: $showReset) {
            Reset()
        }
        .sheet(isPresented: $showTerms) {
            Terms()
        }
        .alert("Deletion may take up to 24 hours.", isPresented:
            $showAlert) {
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
        }}}}}
