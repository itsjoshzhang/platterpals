import SwiftUI

struct Update: View {

    // ## TRACK INFO ## \\
    var id: String
    @State var size = 0.0
    @State var swipe = 0.0
    let min = UIwidth / 2.0

    // ## CONDITIONS ## \\
    @State var showProf = false
    @State var hideProf = false
    @State var showAlert = false

    @EnvironmentObject var DM: DataManager

    // ## OTHER VIEWS ## \\

    var body: some View {
        if hideProf {
            Button("Unhide Profile") {
                withAnimation {
                    hideProf = false }}
        } else {
            content
        }
    }
    // ## SETUP VIEW ## \\

    var content: some View {
        Group {
        let user = DM.user(id: id)
        ZStack {
        let heart = Image(systemName: "heart.fill")

        // ## SHOW IMAGE ## \\

        if let image = DM.myProfile {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(maxHeight: UIheight * 0.75)
                .cornerRadius(16)
                .clipped()
        }
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
        .frame(width: UIwidth - 32, alignment: .center)
        .shadow(color: .black, radius: 3)
        .foregroundColor(.white)
        .padding(16)

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
        .scaleEffect(size)
        .scaledToFit()
        }

        // ## SWIPE LOGIC ## \\

        .gesture(DragGesture()
        .onChanged { drag in
            withAnimation {

                swipe = -(drag.startLocation.x -
                          drag.predictedEndLocation.x)
                size = 1.0
            }
        }
        .onEnded {_ in
            withAnimation {

                if (swipe > min) {
                    showProf = true

                } else if (swipe < -min) {
                    hideProf = true
                }
                size = 0.0
                }
            }
        )
        // ## MODIFIERS ## \\

        .sheet(isPresented: $showProf) {
            UserProf(id: id)
                .environmentObject(DM)
        }
        .alert("Profile Details", isPresented: $showAlert) {

            if (DM.my().id == user.id) {
                Button("Delete Profile", role: .destructive) {
                    DM.delImage(path: "profiles")
                }
            } else {
                Button("Report Profile", role: .destructive) {
                    withAnimation {
                        hideProf = true
                    }}}
            Button("Cancel", role: .cancel) {}
        }}}}
