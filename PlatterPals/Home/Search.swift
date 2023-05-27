import SwiftUI

struct Row: View {

    // ## SETUP VIEW ## \\
    var id: String
    @State var image: UIImage?
    @EnvironmentObject var DM: DataManager

    var body: some View {
        HStack(spacing: 16) {

        // ## SHOW IMAGE ## \\

        RoundPic(width: 64, image: image)

        VStack(alignment: .leading, spacing: 8) {
        let user = DM.user(id: id)

        Text(user.name)
            .foregroundColor(.pink)
            .font(.headline)

        Text("\(user.city)")
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
        .onAppear {
            getImage(path: "avatars")
        }}}

    // ## FUNCTIONS ## \\

    func getImage(path: String) {
        let SR = SR.child("\(path)/\(id).jpg")
        SR.getData(maxSize: 4 * 1024 * 1024) { data,_ in
            if let data = data {
                image = UIImage(data: data)
            }}}}

struct Search: View {

    // ## TRACK INFO ## \\
    @State var name = ""
    @State var city = "All"
    @State var showNext = false
    @State var following = false
    @State var userIDs = [String]()

    // ## SETUP VIEW ## \\
    var profile: Bool
    @FocusState var focus: Bool
    @EnvironmentObject var DM: DataManager

    var body: some View {
        NavigationStack {
        VStack(spacing: 16) {

        // ## TEXTFIELDS ## \\

        Group {
        TextField("Enter a username", text: $name)
            .padding(4)
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(.secondary))
            .submitLabel(.done)
            .focused($focus)

        HStack(spacing: 0) {

        Text("Location: ")
            .foregroundColor(.secondary)
        Cities(addAll: true, city: $city)
            .onChange(of: city) {_ in
                name = ""
            }
        Spacer()

        Toggle("Following ✓", isOn: $following)
            .toggleStyle(.button)
            .onTapGesture {
                following.toggle()
            }}}
        .padding(.horizontal, 16)

        // ## SHOW USERS ## \\

        List {
        ForEach(userIDs, id: \.self) { id in
            NavigationLink(value: id) {
                Row(id: id)
                    .environmentObject(DM)
        }}}
        .listStyle(.plain)
        .opacity(userIDs.isEmpty ? 0: 1)

        .navigationDestination(for: String.self) { id in
            if profile {
                Profile(id: id, pad: -50)
                    .environmentObject(DM)
            } else {
                Convo(id: id, pad: true)
                    .environmentObject(DM)
                }}}
        .navigationTitle("Search 🔍")
        .background {
            Back()
        }
        .onAppear {
            focus = true
        }
        // ## HACKY SHIT ## \\

        .onChange(of: name) {_ in
            userIDs.removeAll()

            for i in (0 ..< min(DM.userList.count, 4)) {
            // loop through userList & show maximum 4 items
            let user = DM.userList[i]

            if !name.isEmpty, compare(user.name, name),
            // if name is valid and is a prefix of user.name

            (following && DM.md().favUsers.contains(user.id))
            // if following checked, show from favUsers only

            || !following, (city == "All" || compare(user.city, city)) {
            // if not & (if no city: pass, else: check city)
                userIDs.append(user.id)
        }}}}}

    func compare(_ name1: String, _ name2: String) -> Bool {
        let l1 = name1.lowercased()
        let l2 = name2.lowercased()
        return (l1.hasPrefix(l2) || l2.hasPrefix(l1))
    }
}
