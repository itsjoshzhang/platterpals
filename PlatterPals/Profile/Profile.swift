import SwiftUI

struct MyProfile: View {

    // ## SETUP VIEW ## \\

    var id: String
    @State var showSets = false
    @EnvironmentObject var DM: DataManager

    var body: some View {
        NavigationStack {
            Profile(id: DM.my().id, avatar: DM.myAvatar, profile:
                        DM.myProfile, showUpdate: true)
                .environmentObject(DM)

        // ## MODIFIERS ## \\

        .navigationTitle(DM.my().name)
        .toolbar {
            ToolbarItem {
                Button("\(Image(systemName: "gearshape"))") {
                    showSets = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .fullScreenCover(isPresented: $showSets) {
            Settings()
                .environmentObject(DM)
            }}}}

struct Profile: View {

    var id: String
    @State var avatar: UIImage?
    @State var profile: UIImage?

    // ## CONDITIONS ## \\
    @State var showEdit = false
    @State var showChat = false
    @State var showUpdate = false

    @EnvironmentObject var DM: DataManager

    // ## SETUP VIEW ## \\

    var body: some View {
        ZStack {
            let myID = DM.my().id
            let user = DM.user(id: id)
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
            Text("\(user.name), CA")
                .font(.headline)
            Spacer()
            Text("♥ \(DM.findHearts(id: user.id))")
                .foregroundColor(.pink)
                .font(.title3)
        }}}
        if showUpdate == false {
            Text(user.text)
                .foregroundColor(.secondary)
        }
        Text("\(user.name)'s favorite foods:")
            .font(.headline)
        // TODO: use aiOrders and favFoods to list favorites
        Text("No favorites yet.")
            .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)

        // ## MODIFIERS ## \\

        VStack {
        Button("\(Image(systemName: "photo"))") {
            withAnimation {
                showUpdate.toggle()}}
        .buttonStyle(.borderedProminent)

        if showUpdate {
            Update(id: id, show: false, avatar: avatar,
                   profile: profile)
            .environmentObject(DM)
        }
        Spacer()
            .padding(36)}}
        .onAppear {
            getImage(path: "avatars")
            getImage(path: "profiles")
        }
        .sheet(isPresented: $showEdit) {
            EditProf()
                .environmentObject(DM)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $showChat) {
            Convo(id: id)
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
