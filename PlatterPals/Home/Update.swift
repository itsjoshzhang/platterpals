import SwiftUI

struct Update: View {

    // ## TRACK INFO ## \\
    var id: String
    var show: Bool
    let min = UIwidth / 2.0
    @State var scale = 0.9
    @State var swipe = 0.0

    // ## CONDITIONS ## \\
    @State var avatar: UIImage?
    @State var profile: UIImage?
    @State var showProf = false
    @State var hideProf = false
    @State var showAlert = false

    @EnvironmentObject var DM: DataManager

    // ## OTHER VIEWS ## \\

    var body: some View {
        if hideProf {
            Button("Unhide Profile") {
                withAnimation {
                    hideProf = false
        }}} else {
            content
        }
    }
    // ## SETUP VIEW ## \\

    var content: some View {
        Group {
            let myID = DM.my().id
            let user = DM.user(id: id)
            let heart = Image(systemName: "heart.fill")

        ZStack {
            if let image = profile {
                let height = UIwidth * 15.5 / 9.0

                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxHeight: height)
                    .cornerRadius(16)
                    .clipped()

        // ## USER INFO ## \\

        VStack(alignment: .leading) {
            Spacer()
            Text(user.name)
                .font(.largeTitle).bold()

            HStack {
                Text("\(user.city), CA")
                    .font(.headline)
                Spacer()

                Text("\(heart) \(user.views)")
                    .font(.headline)

                Button("\(Image(systemName: "flag"))") {
                    showAlert = true
                }
            }
            Text(user.text)
                .padding(.top, 3)
        }
        .shadow(color: .black, radius: 3)
        .foregroundColor(.white)
        .padding(16)

            } else {
                ProgressView()
                    .scaleEffect(2)
                    .tint(.pink)
            }
        // ## SHOW HEARTS ## \\

        Group {
            heart
                .resizable()
                .foregroundColor(.pink)
                .opacity(swipe / min)

            Image(systemName: "heart.slash.fill")
                .resizable()
                .foregroundColor(.white)
                .opacity(swipe / -min)
        }
        .frame(width: min, height: min, alignment: .center)
        .scaleEffect(scale)
        .scaledToFit()
        }
        // ## SWIPE LOGIC ## \\

        .gesture(DragGesture()
        .onChanged { drag in
            withAnimation {

                swipe = -(drag.startLocation.x -
                          drag.predictedEndLocation.x)
                scale = 1.0
            }
        }
        .onEnded {_ in
            withAnimation {
                if (swipe > min && show) {
                    showProf = true

                } else if swipe < -min {
                    hideProf = true
                }
                scale = 0.9
                swipe = 0.0
            }
        }
        )
        // ## GET IMAGES ## \\

        .onAppear {
            if myID == id {
                avatar = DM.myAvatar
                profile = DM.myProfile
            } else {
                getImage(path: "avatars")
                getImage(path: "profiles")
            }
        }
        .sheet(isPresented: $showProf) {
            UserProf(id: id, avatar: avatar, profile: profile)
                .environmentObject(DM)
        }
        // ## EDIT PROFILE ## \\

        .alert("Profile Details", isPresented: $showAlert) {
            if myID == id {

                Button("Delete Profile", role: .destructive) {
                    DM.delImage(path: "profiles")
                }
            } else {
                Button("Report Profile", role: .destructive) {
                    withAnimation {
                        hideProf = true
                    }}}
            Button("Cancel", role: .cancel) {}
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
