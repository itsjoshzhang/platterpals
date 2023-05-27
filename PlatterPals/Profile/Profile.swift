import SwiftUI

struct MyProfile: View {

    // ## TRACK INFO ## \\
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

        if my.prof >= 0 {
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
    @State var avatar: UIImage?
    @State var profile: UIImage?
    @State var showEdit = false
    @State var showChat = false
    @State var showUpdate = false

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
            Text("♥ \(DM.sumHeart(id: user.id))")
                .foregroundColor(.pink)
                .font(.title3)
        }}}
        if !showUpdate {
            Text(user.text)
                .foregroundColor(.secondary)
        }
        Cards(id: user.id)
            .environmentObject(DM)
            .environmentObject(OM)
        }
        .padding(.horizontal, 16)

        // ## SHOW UPDATE ## \\

        VStack {
        if user.prof < 0 {
            Button("\(Image(systemName: "photo"))") {
                withAnimation {
                    showUpdate.toggle()
                }
            }
            .buttonStyle(.borderedProminent)
            .shadow(color: .pink, radius: 3)

            if showUpdate {
                Update(id: id, showNext: false, profile: profile)
                    .environmentObject(DM)
            }
        } else {
            Text("No profile yet.")
                .foregroundColor(.secondary)
        }}}

        // ## MODIFIERS ## \\

        .background() {
            Back()
        }
        .onAppear {
            if avatar == nil {
                getImage(path: "avatars")
            }
            if profile == nil {
                getImage(path: "profiles")
            }
        }
        .sheet(isPresented: $showEdit) {
            EditProf()
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
