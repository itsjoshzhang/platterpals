import SwiftUI

struct Home: View {

    // ## TRACK INFO ## \\
    @State var city = ""
    @State var following = false
    @State var showSearch = false
    @State var showUpload = false

    // ## SETUP VIEW ## \\
    var userList: [User]
    @EnvironmentObject var DM: DataManager

    var body: some View {
        NavigationStack {
        ScrollView {
        LazyVStack(spacing: 16) {

        // ## USER SEARCH ## \\

        Box(text: "Search for a profile")
            .onTapGesture {
                showSearch = true
            }
        HStack {
            Text("City:")
                .foregroundColor(.secondary)
            City(city: $city)
            Spacer()

        Toggle("Following ✓", isOn: $following)
            .toggleStyle(.button)
            .onTapGesture {
                following.toggle()
            }
        }
        .padding(.horizontal, 16)

        // ## HACKY SHIT ## \\

        ForEach(userList) { user in
        // return shuffled copy of userList
        let priv = !DM.sets(id: user.id).privacy

        if DM.my().id != user.id, user.id != "!", priv,
        // dont show my own profile or the debug account

        !DM.md().blocked.contains(user.id), user.prof,
        // don't show blocked users and missing profiles

        // (following && DM.md().favUsers.contains(user.id))
        // if following checked, show from favUsers only

        compare(user.city, city) {
        // if not & (if no city: pass, else: check city)

            let update = Update(id: user.id, showNext: true)
            // show update with link to profile
                            .environmentObject(DM)

            if DM.ms().suggest { update
            // don't suggest restaurant if rest
            } else if !user.rest { update
        }}}}

        // ## MODIFIERS ## \\

        .navigationTitle("PlatterPals")
        .toolbar {
            ToolbarItem {
                Button("Profile \(upbox)"){
                    showUpload = true
                }
            .buttonStyle(.borderedProminent)
            }
        }
        .sheet(isPresented: $showUpload) {
            Upload()
                .environmentObject(DM)
        }
        .sheet(isPresented: $showSearch) {
            Search(profile: true)
                .environmentObject(DM)
        }}
        .background {
            Back()
        }}}
    
    func compare(_ name1: String, _ name2: String) -> Bool {
        return name1.lowercased().hasPrefix(name2.lowercased())
    }
}
