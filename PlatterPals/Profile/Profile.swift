import SwiftUI

struct MyProfile: View {

    // ## SETUP VIEW ## \\

    var id: String
    @State var showSets = false
    @EnvironmentObject var DM: DataManager

    var body: some View {
        NavigationStack {
            Profile(id: DM.my().id, image: DM.myAvatar,
                showUpdate: true)
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

    // ## TRACK INFO ## \\
    var id: String
    var title = false
    @State var image: UIImage?
    @State var showEdit = false
    @State var showChat = false
    @State var showUpdate = false

    @EnvironmentObject var DM: DataManager

    // ## SETUP VIEW ## \\

    var body: some View {
        ZStack(alignment: .top) {
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
            Text("♥ \(DM.findHearts(id: user.id))")
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

        VStack {
        if user.prof {
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
        // ## MODIFIERS ## \\

        } else {
            Text("No profile yet.")
                .foregroundColor(.secondary)
        }}}
        .navigationTitle(user.name)
        .onAppear {
            getImage(path: "avatars")
        }
        .sheet(isPresented: $showEdit) {
            EditProf()
                .environmentObject(DM)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $showChat) {
            Convo(id: id)
                .environmentObject(DM)
        }
        .background() {
            Back()
        }}}

    // ## FUNCTIONS ## \\

    func getImage(path: String) {
        let SR = SR.child("\(path)/\(id).jpg")

        SR.getData(maxSize: 8 * 1024 * 1024) { data,_ in
            if let data = data {

                DispatchQueue.main.async {
                    image = UIImage(data: data)
                }}}}}
