import SwiftUI
import Firebase

struct Settings: View {

    @State var notifs = true
    @State var suggest = true
    @State var privacy = true
    @State var locate = true
    @State var guide = false

    @State var loggedOut = false
    @State var showReset = false
    @State var showTerms = false
    @State var showAlert = false
    @State var showDelete = false

    @State var blockID = "..."
    @State var alertText = ""
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
        ScrollView {
        VStack(alignment: .leading, spacing: 16) {

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
            .frame(maxWidth: UIwidth, alignment: .leading)

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
        Group {
        Text("Profiles")
            .font(.headline)
            .foregroundColor(.black)
        Div()
        HStack {
            Text("Share location on Maps")
            Spacer()
            Toggle("", isOn: $locate)
                .frame(width: 50)
        }
        HStack {
            Text("Restaurant suggestions")
            Spacer()
            Toggle("", isOn: $suggest)
                .frame(width: 50)
            }
        }
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
        Group {
        Text("Account")
            .font(.headline)
            .foregroundColor(.black)
        Div()
        if showDelete {
            HStack {
            Button("Cancel Deletion") {
                DM.sendFlag(id: myID, type: "undelete")
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
                alertText = "Deletion takes up to 24 hours."

                showAlert = true
                showDelete = true
            }
            .buttonStyle(.bordered)
        }
        Button("Terms and EULA") {
            showTerms = true
        }
        }
        .foregroundColor(.pink)
        Spacer()
        }
        .padding(16)
        .foregroundColor(.secondary)
        .navigationTitle("Settings")
        .background {
            Back()
        }
        .onAppear {
            let sets = DM.ms()
            notifs = sets.notifs
            locate = sets.locate
            suggest = sets.suggest
            privacy = sets.privacy

            let doc = FS.collection("accFlags").document(sets.id)
            doc.getDocument { doc,_ in
                let type = doc?.data()?["type"] as? String ?? ""
                showDelete = (type == "delete")
            }
        }
        .sheet(isPresented: $showReset) {
            Reset()
        }
        .sheet(isPresented: $showTerms) {
            Terms()
        }
        .alert(alertText, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        }
        .onChange(of: privacy) { bool in
            alertText = "Your cover photo will be hidden from users."
            showAlert = bool
        }
        .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
        Button("\(Image(systemName: "chevron.left")) Save") {
            var sets = DM.ms()

            sets.notifs = notifs
            sets.locate = locate
            sets.suggest = suggest
            sets.privacy = privacy
            DM.editSets(sets: sets)
            dismiss()
        }
        }
        ToolbarItem {
        let s = "rectangle.portrait.and.arrow.right"
        Button("\(Image(systemName: s))") {

            do { try Auth.auth().signOut()
            } catch { return }
            withAnimation {
                loggedOut = true
            }
        }
        .buttonStyle(.borderedProminent)
        }}}}}}
