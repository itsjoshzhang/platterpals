import SwiftUI

struct UserProf: View {

    // ## TRACK INFO ## \\
    var id: String
    @State var avatar: UIImage?
    @State var profile: UIImage?

    // ## CONDITIONS ## \\
    @State var showEdit = false
    @State var showChat = false
    @State var showSets = false
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
            .padding(50)
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

            Block(id: id)
                .environmentObject(DM)
        }
        }
        // ## USER INFO ## \\

        HStack {
            Text("\(user.city), CA")
                .font(.headline)
            Spacer()
            Text("♥ \(DM.findHearts(id: user.id))")
                .foregroundColor(.pink)
                .font(.title2)
        }}}

        if showUpdate  == false {
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
        }
        // ## MODIFIERS ## \\

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
        .sheet(isPresented: $showChat) {
            Convo(id: id)
                .environmentObject(DM)
        }
        .fullScreenCover(isPresented: $showSets) {
            Settings()
                .environmentObject(DM)
        }}}

    // ## FUNCTIONS ## \\

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
