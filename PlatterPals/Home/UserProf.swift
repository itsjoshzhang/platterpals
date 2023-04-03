import SwiftUI

struct UserProf: View {

    // ## TRACK INFO ## \\
    var id: String
    @State var avatar: UIImage?
    @State var profile: UIImage?

    // ## CONDITIONS ## \\
    @State var showAction = false
    @State var showChatDM = false
    @State var showFollow = false
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
            let myID = DM.my().id
            let user = DM.user(id: id)
            let favs = DM.data(id: myID).favUsers

        ZStack {
            Back()
            ScrollView {

                VStack(alignment: .leading, spacing: 16) {
                    Spacer()
                        .padding(48)
                    HStack(spacing: 16) {
                        RoundPic(image: avatar, width: 80)
        VStack {
            HStack {
                if favs.contains(id) {
                    Button("Following") {
                    }
                    .buttonStyle(.bordered)
                } else {
                    Button("Follow \(Image(systemName: "heart"))") {
                    }
                    .buttonStyle(.borderedProminent)
                }
                Spacer()

                Button("\(Image(systemName: "message.fill"))") {
                    showChatDM = true
                }
                Button("\(Image(systemName: "bell"))") {
                    showAction = true
                }
            }
            HStack {
                Text("\(user.city), CA")
                    .font(.headline)
                Spacer()

                Text("\(Image(systemName: "heart")) \(user.views)")
            }}}
            .padding(.horizontal, 16)

            Group {
                Text(user.text)
                    .foregroundColor(.secondary)

                Text("\(user.name)'s favorite foods:")
                    .font(.headline)

                Text("No favorites yet.")
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)

            Update(id: id, avatar: avatar, profile: profile)

            Spacer().padding(32)
            }}}
            .navigationTitle(user.name)

            .onAppear {
                if (myID == id) {
                    avatar = DM.myAvatar
                    profile = DM.myProfile
                } else {
                    getImage(path: "avatars")
                    getImage(path: "profiles")
                }
            }
            .fullScreenCover(isPresented: $showChatDM) {
                Convo(id: id)
                    .environmentObject(DM)
            }
            .actionSheet(isPresented: $showAction) {
                ActionSheet(title: Text("Notifications"),
                    buttons: [
                        .destructive(Text("Block this user")),
                        .default(Text("Mute notifications")),
                        .cancel(Text("Cancel"))]
                )}}}

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
