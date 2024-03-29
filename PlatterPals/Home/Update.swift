import SwiftUI

struct Update: View {

    var id: String
    var showNext: Bool
    @State var scale = 0.9
    @State var swipe = 0.0

    @State var avatar: UIImage?
    @State var profile: UIImage?
    @State var showProf = false
    @State var hideProf = false
    @State var showAlert = false

    @EnvironmentObject var DM: DataManager

    var body: some View {
        if hideProf {
            Button("Unhide Profile") {
                withAnimation {
                    hideProf = false
        }}
        .foregroundColor(.secondary)
        } else {
            content
        }}
    var content: some View {
        Group {
            var data = DM.md()
            let myID = DM.my().id
            let min = UIwidth * 0.5
            let user = DM.user(id: id)

        ZStack {
        if let profile = profile {

        Image(uiImage: profile)
            .resizable()
            .scaledToFit()
            .frame(maxHeight:
            UIwidth * 16.0 / 9.0)
            .cornerRadius(16)
            .clipped()

        VStack(alignment: .leading) {
            if user.rest {
                Text("\(spark) Restaurant")
                    .font(.headline)
            }
            Spacer()
            Button {
                if showNext {
                    showProf = true
                }
            } label: {
                Text(user.name)
                    .font(.largeTitle).bold()
            }
        HStack {
            Text("\(user.city)")
                .font(.headline)
            Spacer()

            Text("♥ \(DM.sumHeart(id: user.id))")
                .font(.title3)

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
        Group {
            Image(systemName: "heart.fill")
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
                if (swipe > min && showNext) {
                    showProf = true

                    if !data.favUsers.contains(user.id) {
                        data.favUsers.append(user.id)
                        DM.editData(data: data)
                    }
                } else if (swipe < -min && showNext) {
                    hideProf = true
                }
                scale = 0.9
                swipe = 0.0
            }})
        .onAppear {
            if id == myID {
                avatar = DM.myAvatar
                profile = DM.myProfile
            }
            if profile == nil {
                getImage(path: "profiles")
            }
            if avatar == nil {
                getImage(path: "avatars")
            }
        }
        .sheet(isPresented: $showProf) {
            Profile(id: id, pad: 64, avatar: avatar, profile: profile)
                .environmentObject(DM)
        }
        .confirmationDialog("", isPresented: $showAlert) {
            if myID == id {
                Button("DELETE PROFILE") {
                    DM.delImage(path: "profiles")
                }
            } else {
                Button("Report Profile") {
                    DM.sendFlag(id: user.id, type: "report")
                    withAnimation {
                        hideProf = true
                    }}}
            Button("Cancel", role: .cancel) {}
        }}}

    func getImage(path: String) {
        let SR = SR.child("\(path)/\(id).jpg")
        SR.getData(maxSize: 4 * 1024 * 1024) { data,_ in

            if let data = data {
                if path == "avatars" {
                    avatar = UIImage(data: data)
                } else {
                    profile = UIImage(data: data)
                }}}}}
