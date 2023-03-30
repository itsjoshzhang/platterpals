import SwiftUI

struct Update: View {

    // ## TRACK INFO ## \\
    var id: String
    @State var size = 1.0
    @State var swipe = 0.0
    @State var image: UIImage?

    // ## CONDITIONS ## \\
    @State var showProf = false
    @State var hideProf = false
    @State var showAlert = false

    @EnvironmentObject var DM: DataManager

    // ## OTHER VIEWS ## \\

    var body: some View {
        if hideProf {
            Button("Unhide profile") {
                withAnimation {
                    hideProf = false }}
        } else {
            content
        }
    }
    // ## SETUP VIEW ## \\

    var content: some View {
        VStack(alignment: .leading, spacing: 16) {
            let user = DM.user(id: id)
            let min = UIwidth / 4.0
            ZStack {

                // ## SHOW IMAGE ## \\

                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxHeight: UIheight * 0.75)
                        .clipped()

                // ## SWIPE LOGIC ## \\

                .gesture(
                    DragGesture(minimumDistance: min
                )
                .onChanged { drag in
                    swipe = drag.translation.width
                    size = 1.0
                }
                .onEnded { drag in
                    withAnimation(.easeIn(duration: 0.25)) {
                        let drag = drag.translation.width

                        if (drag > min) {
                            showProf = true
                        } else if (drag < -min) {
                            hideProf = true
                        }
                        size = 0.0
                    }})}

                // ## SHOW HEARTS ## \\

                Group {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .foregroundColor(.pink)
                        .opacity(swipe / 200.0)

                    Image(systemName: "heart.slash.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .opacity(swipe / -200.0)
                }
                .frame(width: 200)
                .scaleEffect(size)
                .scaledToFit()

                // ## USER INFO ## \\

                Rectangle()

                Group {
                    Text(user.name)
                    Text(user.city)
                    Text(user.text)

                    Text("\(Image(systemName: "heart.fill")) \(user.views)")
                }
                .padding(16)
            }
        }
        // ## MODIFIERS ## \\

        .onAppear {
            getImage(id: id)
        }
        .sheet(isPresented: $showProf) {
            UserProf(id: id)
                .environmentObject(DM)
        }
        .alert("Profile Details", isPresented: $showAlert) {
            let id = DM.user(id: id).id

            if id == DM.my().id {
                Button("Delete Profile", role: .destructive) {
                    DM.delImage(path: "profiles")
                }
            } else {
                Button("Report Profile", role: .destructive) {
                    withAnimation {
                        hideProf = true
                    }}}
            Button("Cancel", role: .cancel) {}
        }
    }
    // ## FUNCTIONS ## \\

    func getImage(id: String) {
        let SR = SR.child("profiles/\(id).jpg")

        SR.getData(maxSize: 8 * 1024 * 1024) { data, error in
            if let data = data {

                DispatchQueue.main.async {
                    image = UIImage(data: data)
                }}}}}
