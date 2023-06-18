import SwiftUI

struct Home: View {

    @State var city = ""
    @State var following = false
    @State var showSearch = false
    @State var showUpload = false

    var userList: [User]
    @EnvironmentObject var DM: DataManager

    var body: some View {
        NavigationStack {
        ScrollView {
        LazyVStack(spacing: 16) {

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

        ForEach(userList) { user in
        let priv = !DM.sets(id: user.id).privacy

        if DM.my().id != user.id, user.id != "!", priv,
        !DM.md().blocked.contains(user.id), user.prof,

        // (following && DM.md().favUsers.contains(user.id))
        compare(user.city, city) {

            let update = Update(id: user.id, showNext: true)
                            .environmentObject(DM)

            if DM.ms().suggest { update
            } else if !user.rest { update
        }}}}

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
