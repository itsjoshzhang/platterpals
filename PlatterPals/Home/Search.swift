import SwiftUI

struct Row: View {

    var id: String
    @State var image: UIImage?
    @EnvironmentObject var DM: DataManager

    var body: some View {
        HStack(spacing: 16) {

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
            if image == nil {
                getImage(path: "avatars")
            }}}}

    func getImage(path: String) {
        let SR = SR.child("\(path)/\(id).jpg")
        SR.getData(maxSize: 4 * 1024 * 1024) { data,_ in
            if let data = data {
                image = UIImage(data: data)
            }}}}

struct Search: View {

    @State var name = ""
    @State var city = ""
    @State var showNext = false
    @State var following = false
    @State var userIDs = [String]()

    var profile: Bool
    @FocusState var focus: Bool
    @EnvironmentObject var DM: DataManager

    var body: some View {
        NavigationStack {
        VStack(spacing: 16) {

        Group {
        TextField("Enter a username", text: $name)
            .padding(4)
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(.secondary))
            .submitLabel(.done)
            .focused($focus)

        HStack {
            Text("City:")
                .foregroundColor(.secondary)
            City(city: $city)
            Spacer()

        Toggle("Following ✓", isOn: $following)
            .toggleStyle(.button)
            .onTapGesture {
                following.toggle()
            }}}
        .padding(.horizontal, 16)

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
        .onChange(of: name) {_ in
            search()
        }
        .onChange(of: city) {_ in
            search()
        }
        .onChange(of: following) {_ in
            search()
        }}}

    func search() {
        userIDs.removeAll()

        for i in 0 ..< DM.userList.count {
            let user = DM.userList[i]

            if userIDs.count < 4, compare(user.name, name),
            (following && DM.md().favUsers.contains(user.id))

            || !following, compare(user.city, city) {
                userIDs.append(user.id)
        }}}

    func compare(_ name1: String, _ name2: String) -> Bool {
        return (name1 != "!" && !(name.isEmpty && city.isEmpty) &&
        name1.lowercased().hasPrefix(name2.lowercased()))
    }
}
