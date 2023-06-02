import SwiftUI

struct MyProfile: View {

    // ## TRACK INFO ## \\
    @State var image: UIImage?
    @State var showSetts = false
    @State var showUpload = false
    @EnvironmentObject var DM: DataManager

    var body: some View {
        NavigationStack {
        ZStack {
            let my = DM.my()

        // ## SHOW PROFILE ## \\

        Profile(id: my.id, pad: 0, avatar: DM.myAvatar, profile:
            DM.myProfile, showUpdate: true)
            .environmentObject(DM)

        .onAppear {
            image = DM.myAvatar
        }
        .toolbar {
            ToolbarItem {
                Button("\(Image(systemName: "gearshape"))") {
                    showSetts = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .sheet(isPresented: $showUpload) {
            Upload()
                .environmentObject(DM)
        }
        .fullScreenCover(isPresented: $showSetts) {
            Settings()
                .environmentObject(DM)
        }
        // ## SHOW BUTTON ## \\

        if !my.prof {
            VStack {
                Spacer()
            Button {
                showUpload = true
            } label: {
                Glow(text: "No profile yet? Add one now!")
            }}}}}}}

struct Profile: View {

    // ## TRACK INFO ## \\
    var id: String
    var pad: Int
    @State var page = ""
    @State var avatar: UIImage?
    @State var profile: UIImage?

    // ## BOOLEANS ## \\
    @State var showEdit = false
    @State var showChat = false
    @State var showUpdate = false
    @State var showUpload = false

    // ## SETUP VIEW ## \\
    @StateObject var OM = OrderManager()
    @EnvironmentObject var DM: DataManager

    var body: some View {
        Group {
            let myID = DM.my().id
            let user = DM.user(id: id)
            
        ScrollView {
        VStack(alignment: .leading, spacing: 16) {

        Text(user.name)
            .font(.largeTitle).bold()
            .padding(.top, CGFloat(pad))

        HStack(spacing: 16) {
            RoundPic(width: 80, image: avatar)

        // ## CLICKABLES ## \\

        VStack(alignment: .leading) {
        if myID == id {
            HStack(spacing: 16) {
            Button("Edit Profile") {
                showEdit = true
            }
            .buttonStyle(.bordered)
            Button("Upload \(upbox)") {
                showUpload = true
            }
            .buttonStyle(.borderedProminent)
            }
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
            Text("\(user.city)")
                .font(.headline)
            Spacer()
            Text("♥ \(DM.sumHeart(id: user.id))")
                .foregroundColor(.pink)
                .font(.title3)
        }}}
        if !(showUpdate && user.prof) {
            Text(user.text)
                .foregroundColor(.secondary)
        }
        Cards(id: user.id, page: $page)
            .environmentObject(DM)
            .environmentObject(OM)
        }
        .padding(.horizontal, 16)

        // ## SHOW UPDATE ## \\

        VStack {
        Button("\(Image(systemName: "photo"))") {
            withAnimation {
                showUpdate.toggle()
            }
        }
        .buttonStyle(.borderedProminent)

        if showUpdate {
        if (DM.sets(id: user.id).privacy && user.id != myID) {
            Text("Private profile.")
                .foregroundColor(.secondary)
                .padding(16)

        } else if user.prof {
            Update(id: id, showNext: false, profile: profile)
                .environmentObject(DM)
        } else {
            Text("No profile yet.")
                .foregroundColor(.secondary)
                .padding(16)
        }}}}

        // ## MODIFIERS ## \\

        .background() {
            Back()
        }
        .onAppear {
            getImage(path: "avatars")
            getImage(path: "profiles")
        }
        .sheet(isPresented: $showEdit) {
            NavigationStack {
                EditProf(image: avatar)

        .environmentObject(DM)
        .navigationTitle("Edit Profile")
        .background {
            Back()
        }}}
        .sheet(isPresented: $showUpload) {
            Upload()
                .environmentObject(DM)
        }
        .sheet(isPresented: $showChat) {
            Convo(id: id, pad: false)
                .environmentObject(DM)
        }}}

    // ## FUNCTIONS ## \\

    func getImage(path: String) {
        let SR = SR.child("\(path)/\(id).jpg")
        SR.getData(maxSize: 4 * 1024 * 1024) { data,_ in
            if let data = data {
                if path == "avatars" {
                    avatar = UIImage(data: data)
                } else {
                    profile = UIImage(data: data)
                }}}}}
