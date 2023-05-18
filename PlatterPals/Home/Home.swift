import SwiftUI

struct Home: View {

    // ## TRACK INFO ## \\
    @State var city = "Berkeley"
    @State var following = false
    @State var showSearch = false
    @State var showUpload = false

    @EnvironmentObject var DM: DataManager

    // ## SETUP VIEW ## \\

    var body: some View {
        NavigationStack {
        ZStack {
        Back()

        ScrollView {
        VStack(spacing: 16) {
        Spacer()
            .padding(50)

        // ## USER SEARCH ## \\

        Box()
            .onTapGesture {
                showSearch = true
            }
        HStack(spacing: 0) {
            Text("Location:")
                .foregroundColor(.secondary)

            Picker("", selection: $city) {
                ForEach(["Berkeley"], id: \.self) { city in
                    Text(city)
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

        // ## PROFILES ## \\

        ForEach(DM.userList) { user in

        let data = DM.md()
        let update = Update(id: user.id, show: true)
            .environmentObject(DM)

        if (!data.blocked.contains(user.id) &&
            DM.my().id != user.id &&
            user.city == city) {

            if following {
                if data.favUsers.contains(user.id) { update }
            } else { update }}}
        Spacer()
            .padding(36)
        }
        // ## MODIFIERS ## \\

        .navigationTitle("PlatterPals")
        .toolbar {
            ToolbarItem {
            Button("\(Image(systemName: "square.and.arrow.up"))") {
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
            Search(forProfile: true)
                .environmentObject(DM)
        }}}}}}
