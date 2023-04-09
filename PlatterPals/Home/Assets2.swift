import SwiftUI

struct Row: View {

    // ## SETUP VIEW ## \\
    var id: String
    @State var image: UIImage?
    @EnvironmentObject var DM: DataManager

    var body: some View {
        HStack(spacing: 16) {
            let user = DM.user(id: id)

            // ## SHOW IMAGE ## \\

            RoundPic(width: 64, image: image)

        VStack(alignment: .leading, spacing: 8) {
            Text(user.name)
                .font(.headline)

            Text("\(user.city), CA")
                .foregroundColor(.secondary)
        }
        }
        .frame(alignment: .leading)
        .onAppear {
            getImage(id: id, path: "avatars")
        }
    }
    // ## FUNCTIONS ## \\

    func getImage(id: String, path: String) {
        let SR = SR.child("\(path)/\(id).jpg")

        SR.getData(maxSize: 8 * 1024 * 1024) { data,_ in
            if let data = data {

                DispatchQueue.main.async {
                    image = UIImage(data: data)
                }}}}}

struct Search: View {

    // ## TRACK INFO ## \\
    @State var name = ""
    @State var newID = ""
    @State var city = "Berkeley"

    @State var showProf = false
    @State var following = false
    @State var idList = [String]()
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var DM: DataManager

    // ## TEXTFIELDS ## \\

    var body: some View {
        NavigationStack {
        VStack(spacing: 16) {

            TextField("Type in a username", text: $name)
                .shadow(color: .pink, radius: 3)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled(true)
                .padding(.horizontal, 16)
                .foregroundColor(.pink)

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
        ForEach(idList, id: \.self) { id in
        Group {

        let user = DM.user(id: id)
        let row = Row(id: id)
            .environmentObject(DM)

        if following {
            let f = DM.data(id: DM.my().id).favUsers

            if (f.contains(id) && user.city == city) {
                row
        }} else if (user.city == city) {
            row
        }}
        .onTapGesture {
            newID = id
            showProf = true
        }}}
        .listStyle(.plain)
        }
        // ## USER LOGIC ## \\
        
        .navigationTitle("Search 🔍")

        .onChange(of: name) { _ in
            idList.removeAll()

            for i in (0 ..< min(DM.userList.count, 4)) {
                let user = DM.userList[i]

                if user.name.lowercased().contains(
                    name.lowercased()) {
                    idList.append(user.id)
                }}}

        .sheet(isPresented: $showProf) {
            UserProf(id: newID)
                .environmentObject(DM)
            }}}}
