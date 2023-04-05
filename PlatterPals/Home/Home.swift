import SwiftUI

struct Home: View {

    // ## TRACK INFO ## \\
    @State var name = ""
    @State var city = "Berkeley"
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

        TextField("Search...", text: $name)
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
                ForEach(["Berkeley", "All"], id: \.self) {city in
                    Text(city)
                }
            }
        }
        // ## PROFILES ## \\

        ForEach(DM.userList, id: \.self) { user in
            let id = DM.my().id
            let city = DM.my().city

            if user.id != id {
                Update(id: user.id, show: true)
                    .environmentObject(DM)
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
