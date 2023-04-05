import SwiftUI

struct Row: View {

    var id: String
    @State var image: UIImage?
    @EnvironmentObject var DM: DataManager

    var body: some View {
        HStack(spacing: 16) {
            let user = DM.user(id: id)

            RoundPic(image: image, width: 64)

            VStack(alignment: .leading, spacing: 8) {
                Text(user.name)
                    .font(.headline)

                Text("\(user.city), CA")
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            getImage(id: id, path: "avatars")
        }
    }
    func getImage(id: String, path: String) {
        let SR = SR.child("\(path)/\(id).jpg")

        SR.getData(maxSize: 8 * 1024 * 1024) { data, error in
            if let data = data {

                DispatchQueue.main.async {
                    image = UIImage(data: data)
                }}}}}

struct Search: View {

    // ## TRACK INFO ## \\
    @State var name = ""
    @State var newID = ""
    @State var showProf = false
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

        // ## SHOW USERS ## \\

        List {
            ForEach(idList, id: \.self) { id in

                Row(id: id).environmentObject(DM)
                    .onTapGesture {
                        newID = id
                        showProf = true
                    }
            }
        }
        .listStyle(.plain)
        }
        .navigationTitle("Search 🔍")

        // ## USER LOGIC ## \\

        .onChange(of: name) { _ in
        idList.removeAll()

        for i in (0 ..< min(DM.userList.count, 4)) {
            let user = DM.userList[i]

            if user.name.contains(name) {
                idList.append(user.id)
            }}}

        .sheet(isPresented: $showProf) {
        UserProf(id: newID)
            .environmentObject(DM)
        }}}}
