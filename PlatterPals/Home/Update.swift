import SwiftUI

struct Update: View {

    // ## TRACK INFO ## \\
    var id: String
    var showNext: Bool
    @State var scale = 0.9
    @State var swipe = 0.0

    // ## CONDITIONS ## \\
    @State var image: UIImage?
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
            let min = UIwidth * 0.5
            let user = DM.user(id: id)

        ZStack {
        if let image = image {
        let height = UIwidth * 16.0 / 9.0

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

            Text("♥ \(DM.findHearts(id: user.id))")
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

        // ## OTHER VIEWS ## \\

        } else if myID == id {
            Text("No profile yet? Create one!")
                .foregroundColor(.pink)
                .font(.headline)
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
                if (swipe > min && showNext) {
                    showProf = true

                } else if swipe < -min {
                    hideProf = true
                }
                scale = 0.9
                swipe = 0.0
            }})

        // ## MODIFIERS ## \\

        .onAppear {
            getImage(path: "profiles")
        }
        .sheet(isPresented: $showProf) {
            Profile(id: id, title: true)
                .environmentObject(DM)
        }
        .confirmationDialog("", isPresented: $showAlert) {
            if myID == id {
                Button("DELETE PROFILE") {
                    DM.delImage(path: "profiles")
                }
            } else {
                Button("Report Profile") {
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
                    image = UIImage(data: data)
                }}}}}
