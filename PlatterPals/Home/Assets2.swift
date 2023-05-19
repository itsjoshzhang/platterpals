import SwiftUI

struct Row: View {

    // ## SETUP VIEW ## \\
    var id: String
    @State var image: UIImage?
    @EnvironmentObject var DM: DataManager

    var body: some View {
        ZStack {
        Rectangle()
            .fill(.white)
        HStack(spacing: 16) {

        // ## SHOW IMAGE ## \\

        RoundPic(width: 64, image: image)

        VStack(alignment: .leading, spacing: 8) {
        let user = DM.user(id: id)

        Text(user.name)
            .foregroundColor(.pink)
            .font(.headline)

        Text("\(user.city), CA")
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
        }
        .frame(maxWidth: UIwidth - 32, alignment: .leading)
        }
        .onAppear {
            getImage(path: "avatars")
        }
    }
    // ## FUNCTIONS ## \\

    func getImage(path: String) {
        let SR = SR.child("\(path)/\(id).jpg")

        SR.getData(maxSize: 8 * 1024 * 1024) { data,_ in
            if let data = data {

                DispatchQueue.main.async {
                    image = UIImage(data: data)
                }}}}}

struct Search: View {

    // ## TRACK INFO ## \\
    @State var name = ""
    @State var showNext = false
    @State var following = false
    @State var city = "Berkeley"
    @State var userIDs = [String]()

    // ## SETUP VIEW ## \\
    var forProfile: Bool
    @FocusState var focus: Bool
    @EnvironmentObject var DM: DataManager

    var body: some View {
        NavigationStack {
        ZStack{
        Back()
        VStack(spacing: 16) {

        // ## TEXTFIELDS ## \\

        TextField("Type in a username", text: $name)
            .padding(4)
            .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(.secondary))

            .padding(.horizontal, 16)
            .padding(.top, 256)
            .focused($focus)

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

        // ## SHOW USERS ## \\

        List {
        ForEach(userIDs, id: \.self) { id in

        let link = NavigationLink(value: id) {
            Row(id: id)
                .environmentObject(DM)
        }
        if following {
            if DM.md().favUsers.contains(id) { link }
        } else { link }}}

        .listStyle(.plain)
        .opacity(userIDs.isEmpty ? 0: 1)

        .navigationDestination(for: String.self) { id in
            if forProfile {
                Profile(id: id)
                    .environmentObject(DM)
            } else {
                Convo(id: id)
                    .environmentObject(DM)
                }}}

        // ## LIST LOGIC ## \\

        .navigationTitle("Search 🔍")
        .onAppear {
            focus = true
        }
        .onChange(of: name) { _ in
            userIDs.removeAll()

            for i in (0 ..< min(DM.userList.count, 4)) {
                let user = DM.userList[i]

                if (compare(name, user.name) && !name.isEmpty) {
                    userIDs.append(user.id)
        }}}}}}

    func compare(_ name1: String, _ name2: String) -> Bool {
        let l1 = name1.lowercased()
        let l2 = name2.lowercased()
        return (l1.hasPrefix(l2) || l2.hasPrefix(l1))
    }
}
