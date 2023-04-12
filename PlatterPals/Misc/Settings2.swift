import SwiftUI

struct Settings2: View {

    @State var notifs = true
    @State var suggest = true
    @State var privacy = true
    @State var location = true

    @State var showReset = false
    @State var showTerms = false
    @State var showDelete = false
    @State var toggle = false

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        ZStack {
        Back()
        VStack(alignment: .leading, spacing: 14) {

        Group {
        HStack {
            Text("Chats")
                .font(.headline)
            Spacer()
            Button("Save Edits") {

                var sets = DM.settings
                sets.notifs = notifs
                sets.suggest = suggest
                sets.privacy = privacy
                sets.location = location

                DM.editSets(sets: sets)
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        Div()
        Text("Blocked users: None")
                .foregroundColor(.secondary)
        HStack {
            Text("Allow chat notifications")
                .foregroundColor(.secondary)
            Spacer()
            Toggle("", isOn: $notifs)
                .frame(width: 64)
        }
        }
        Group {
        Text("Home")
            .font(.headline)
        Div()
        HStack {
            Text("Allow profile suggestions")
                .foregroundColor(.secondary)
            Spacer()
            Toggle("", isOn: $suggest)
                .frame(width: 64)
        }
        HStack {
            Text("Show location to restaurants")
                .foregroundColor(.secondary)
            Spacer()
            Toggle("", isOn: $location)
                .frame(width: 64)
        }
        }
        Group {
        Text("Orders")
            .font(.headline)
        Div()
        Text("Order history: None")
            .foregroundColor(.secondary)
        Text("Favorite foods: None")
            .foregroundColor(.secondary)
        }

        Group {
        Text("Security")
            .font(.headline)
        Div()
        HStack {
            Text(DM.my().id)

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
                .frame(width: 64)
        }
        }
        Group {
        Text("Account")
            .font(.headline)
        Div()
        Button("Terms and EULA") {
            showTerms = true
        }
        if toggle {
            HStack {
                Button("Cancel deletion") {
                    showDelete = false
                    toggle = false
                }
                .buttonStyle(.bordered)

                Text("Deletion processing")
                    .foregroundColor(.secondary)
            }
        } else {
            Button("Delete account") {
                showDelete = true
                toggle = true
            }
            .buttonStyle(.bordered)
        }}}}

        .sheet(isPresented: $showReset) {
        Reset()
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $showTerms) {
        Terms()
        }
        .alert(isPresented: $showDelete) {
        Alert(title: Text("Delete account"),
              message: Text("Deletion may take up to 24 hours."),
              dismissButton: .default(Text("Continue")))
        }
        .onAppear {
            let sets = DM.settings
            notifs = sets.notifs
            suggest = sets.suggest
            privacy = sets.privacy
            location = sets.location
        }
        .padding(.horizontal, 16)
    }
}
