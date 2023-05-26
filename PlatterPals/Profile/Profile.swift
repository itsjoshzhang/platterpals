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

        Profile(id: my.id, title: false,
            image: DM.myAvatar, showUpdate: true)
            .environmentObject(DM)
            .navigationTitle(my.name)

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
    var title: Bool
    @State var image: UIImage?
    @State var showEdit = false
    @State var showChat = false
    @State var showUpdate = false

    // ## SETUP VIEW ## \\
    @EnvironmentObject var DM: DataManager

    var body: some View {
        Group {
            let myID = DM.my().id
            let user = DM.user(id: id)
            
        ScrollView {
        VStack(alignment: .leading, spacing: 16) {

        if title {
            Text(user.name)
                .font(.largeTitle).bold()
                .padding(.top, 64)
        }
        HStack(spacing: 16) {
            RoundPic(width: 80, image: image)

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
                Update(id: id, showNext: false)
                    .environmentObject(DM)
            }
        } else {
            Text("No profile yet.")
                .foregroundColor(.secondary)
        }}}

        // ## MODIFIERS ## \\

        .navigationTitle(user.name)
        .background() {
            Back()
        }
        .onAppear {
            getImage(path: "avatars")
        }
        .sheet(isPresented: $showEdit) {
            EditProf()
                .environmentObject(DM)
        }
        .sheet(isPresented: $showChat) {
            Convo(id: id, padding: false)
                .environmentObject(DM)
        }}}

    // ## FUNCTIONS ## \\

    func getImage(path: String) {
        let SR = SR.child("\(path)/\(id).jpg")
        SR.getData(maxSize: 8 * 1024 * 1024) { data,_ in

            if let data = data {
                DispatchQueue.main.async {
                    image = UIImage(data: data)
                }}}}}
