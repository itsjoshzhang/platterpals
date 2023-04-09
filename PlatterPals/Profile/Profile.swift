import SwiftUI

struct UserProf: View {

    // ## TRACK INFO ## \\
    var id: String
    @State var views = 1
    @State var avatar: UIImage?
    @State var profile: UIImage?
    @Environment(\.dismiss) var dismiss

    // ## CONDITIONS ## \\
    @State var showEdit = false
    @State var showChat = false
    @State var showSets = false
    @State var showAlert = false
    @State var showUpdate = false

    @EnvironmentObject var DM: DataManager

    // ## SETUP VIEW ## \\

    var body: some View {
        NavigationStack {
            let myID = DM.my().id
            let user = DM.user(id: id)

        ZStack {
        Back()
        ScrollView {
        VStack(alignment: .leading, spacing: 16) {

        Spacer()
            .padding(48)
        HStack(spacing: 16) {
            RoundPic(width: 80, image: avatar)

        // ## CLICKABLES ## \\

        VStack(alignment: .leading) {
            if myID == id {
                Button("Edit Profile") {
                    showEdit = true
                }
                .buttonStyle(.bordered)

            } else {
        HStack {
            ProfHead(id: id)
                .environmentObject(DM)
            Spacer()

            Button("\(Image(systemName: "message.fill"))") {
                showChat = true
            }
            .buttonStyle(.borderedProminent)

            Button("\(Image(systemName: "bell"))") {
                showAlert = true
            }
            .buttonStyle(.bordered)
        }
        }
        // ## USER INFO ## \\

        HStack {
            Text("\(user.city), CA")
                .font(.headline)
            Spacer()

            Text("\(Image(systemName: "heart")) \(views)")
        }
        }
        }
        if !showUpdate {
            Text(user.text)
                .foregroundColor(.secondary)
        }
        Text("\(user.name)'s favorite foods:")
            .font(.headline)

        Text("No favorites yet.")
            .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)

        // ## SHOW IMAGE ## \\

        Button("\(Image(systemName: "photo"))") {
            withAnimation {
                showUpdate.toggle()
            }
        }
        .buttonStyle(.borderedProminent)
        .shadow(color: .pink, radius: 3)

        if showUpdate {
            Update(id: id, show: false, avatar: avatar,
                   profile: profile)
            .environmentObject(DM)
        }
        Spacer()
            .padding(36)
        }
        }
        // ## MODIFIERS ## \\

        .navigationTitle(user.name)
        .onAppear {
            if myID == id {
                showUpdate = true
                avatar = DM.myAvatar
                profile = DM.myProfile
            } else {
                getImage(path: "avatars")
                getImage(path: "profiles")
            }
            views = 1
            for data in DM.userData {
                if data.favUsers.contains(id) {
                    views += 1
                }
            }
        }
        // ## OTHER VIEWS ## \\

        .toolbar {
            if myID == id {
                ToolbarItem {
                    Button("\(Image(systemName: "gearshape"))") {
                        showSets = true
                    }
                    .buttonStyle(.borderedProminent)
                }}}
        .sheet(isPresented: $showEdit) {
            EditProf()
                .environmentObject(DM)
                .presentationDetents([.medium])
        }
        .fullScreenCover(isPresented: $showChat) {
            Convo(id: id)
                .environmentObject(DM)
        }
        .fullScreenCover(isPresented: $showSets) {
            Settings()
                .environmentObject(DM)
        }
        // ## BLOCK USER ## \\

        .confirmationDialog("", isPresented: $showAlert) {
            var data = DM.data(id: myID)

            if data.blocked.contains(id) {
                Button("UNBLOCK USER") {

                    if let i = data.blocked.firstIndex(of: id) {
                        data.blocked.remove(at: i)
                        editData(data: data)
                    }
                }
            } else {
                Button("Block this user") {
                    data.blocked.append(id)
                    editData(data: data)
                }}}}}

    // ## FUNCTIONS ## \\

    func editData(data: UserData) {
        DM.editData(id: data.id, fo: data.favFoods, us:
            data.favUsers, ch: data.chatting, bl: data.blocked)
    }

    func getImage(path: String) {
        let SR = SR.child("\(path)/\(id).jpg")

        SR.getData(maxSize: 8 * 1024 * 1024) { data,_ in
            if let data = data {

                DispatchQueue.main.async {
                    if path == "avatars" {
                        avatar = UIImage(data: data)
                    } else {
                        profile = UIImage(data: data)
                    }}}}}}
