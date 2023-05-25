import SwiftUI

struct Home: View {

    // ## TRACK INFO ## \\
    @State var city = "All"
    @State var following = false
    @State var showSearch = false
    @State var showUpload = false

    // ## SETUP VIEW ## \\
    @EnvironmentObject var DM: DataManager

    var body: some View {
        NavigationStack {
        ScrollView {
        VStack(spacing: 16) {

        // ## USER SEARCH ## \\

        Box()
            .onTapGesture {
                showSearch = true
            }
        HStack(spacing: 0) {
        Text("Location:")
            .foregroundColor(.secondary)

        Picker("", selection: $city) {
            ForEach(["All"] + cityList, id: \.self) {
                Text($0)
            }
        }
        Spacer()

        Toggle("Following ✓", isOn: $following)
            .toggleStyle(.button)
            .onTapGesture {
                following.toggle()
            }
        }
        .padding(.horizontal, 16)

        // ## HACKY SHIT ## \\

        ForEach(DM.userList.shuffled()) { user in
        // return shuffled copy of userList
        let data = DM.md()

        if DM.my().id != user.id, user.prof,
        // dont show my own prof, user must have a prof

            !data.blocked.contains(user.id),
            // don't show blocked users

            (following && data.favUsers.contains(user.id))
            // if following checked, show from favUsers only

            || !following, (city == "All" || user.city == city) {
            // if not & (if no city: pass, else: check city)

                Update(id: user.id, showNext: true)
                // show update with link to profile
                    .environmentObject(DM)
            }}}

        // ## MODIFIERS ## \\

        .navigationTitle("PlatterPals")
        .background {
            Back()
        }
        .toolbar {
            ToolbarItem {
                Button("\(Image(systemName: "square.and.arrow.up"))"){
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
        }}}}}
