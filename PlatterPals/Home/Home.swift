import SwiftUI

struct Home: View {

    // ## TRACK INFO ## \\
    @State var name = ""
    @State var city = "Berkeley"
    @State var following = false
    @FocusState var focus: Bool
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
            .padding(48)

        // ## USER SEARCH ## \\

        TextField("Search for a user:", text: $name)
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal, 16)
            .focused($focus)
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

        // ## PROFILES ## \\

            Toggle("Following ✓", isOn: $following)
                .toggleStyle(.button)
                .onTapGesture {
                    following.toggle()
                }
        }
        .padding(.horizontal, 16)

        ForEach(DM.userList, id: \.self) { user in
            let id = DM.my().id

            let update = Update(id: user.id, show: true)
                .environmentObject(DM)

            if following {
                let favs = DM.data(id: id).favUsers

                if (favs.contains(user.id) && user.city == city) {
                    update
                }
            } else if (user.id != id && user.city == city) {
                update
                }
            }
        }
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
            Search()
                .environmentObject(DM)
        }}}}}
