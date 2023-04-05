import SwiftUI

struct UserProf: View {

    // ## TRACK INFO ## \\
    var id: String
    @State var avatar: UIImage?
    @State var profile: UIImage?
    @Environment(\.dismiss) var dismiss

    // ## CONDITIONS ## \\
    @State var showEdit = false
    @State var showChat = false
    @State var showSets = false
    @State var showUpdate = false
    @State var showAction = false

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
            RoundPic(image: avatar, width: 80)

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
                        showAction = true
                    }
                    .buttonStyle(.bordered)
                }
            }
            // ## USER INFO ## \\

            HStack {
                Text("\(user.city), CA")
                    .font(.headline)
                Spacer()

                Text("\(Image(systemName: "heart")) \(user.views)")
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
            }
            .toolbar {
                if myID == id {
                    ToolbarItem {
                        Button("\(Image(systemName: "gearshape"))") {
                            showSets = true
                        }
                        .buttonStyle(.borderedProminent)
                    }}}

            // ## OTHER VIEWS ## \\

            .sheet(isPresented: $showEdit) {
                Text("Hi")
            }
            .fullScreenCover(isPresented: $showChat) {
                Convo(id: id)
                    .environmentObject(DM)
            }
            .fullScreenCover(isPresented: $showSets) {
                Settings()
                    .environmentObject(DM)
            }
            .actionSheet(isPresented: $showAction) {
                ActionSheet(title: Text("Notifications"),
                    buttons: [
                        .destructive(Text("Block this user")),
                        .default(Text("Mute notifications")),
                        .cancel(Text("Cancel"))]
                )}}}
    
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
