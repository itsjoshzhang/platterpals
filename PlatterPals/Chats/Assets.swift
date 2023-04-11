import SwiftUI

struct TitleBar: View {

    // ## TRACK INFO ## \\
    var id: String
    @State var image: UIImage?
    @State var showProf = false
    @State var showAlert = false
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var DM: DataManager

    // ## SETUP VIEW ## \\

    var body: some View {
        VStack {
        HStack(spacing: 16) {
        Button {
            showProf = true
        } label: {
        HStack(spacing: 16) {

        // ## USER INFO ## \\

        RoundPic(width: 80, image: image)

        VStack(alignment: .leading) {
            let user = DM.user(id: id)
            Text(user.name)
                .font(.largeTitle).bold()

            Text("\(user.city), CA")
                .font(.headline)
                .foregroundColor(.secondary)
        }}}
        .frame(width: UIwidth, alignment: .leading)

        Button("\(Image(systemName: "arrowshape.turn.up.backward.2"))") {
            dismiss()
        }
        Button("\(Image(systemName: "bell"))") {
            showAlert = true
        }
        }
        .padding(.horizontal, 16)
        Div()

        // ## MODIFIERS ## \\
        }
        .onAppear {
            getImage(id: id, path: "avatars")
        }
        .sheet(isPresented: $showProf) {
            UserProf(id: id)
                .environmentObject(DM)
        }
        .confirmationDialog("", isPresented: $showAlert) {
            Button("Block this user") {
                var my = DM.data(id: DM.my().id)

                my.blocked.append(id)
                DM.editData(id: my.id, fo: my.favFoods, us:
                    my.favUsers, ch: my.chatting, bl: my.blocked)
            }}}

    // ## FUNCTIONS ## \\

    func getImage(id: String, path: String) {
        let SR = SR.child("\(path)/\(id).jpg")

        SR.getData(maxSize: 8 * 1024 * 1024) { data, error in
            if let data = data {

                DispatchQueue.main.async {
                    image = UIImage(data: data)
                }}}}}

struct Bubble: View {

    // ## SETUP VIEW ## \\
    var message: Message
    @State var showTime = false
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        let sender = (message.sender == DM.my().id)
        VStack(alignment: sender ? .trailing: .leading) {

            // ## SHOW TEXT ## \\

            Text(message.text)
                .padding(16)
                .background(sender ? .pink.opacity(0.25): .secondary)
                .cornerRadius(32)

                .frame(width: UIwidth, alignment: sender ?
                    .trailing: .leading)
                .onTapGesture {
                    showTime.toggle()
                }
            // ## SHOW TIME ## \\

            if showTime {
                let time = message.time.formatted(.dateTime.hour()
                    .minute())
                Text("\(time)")
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 16)
                    .font(.caption)
            }
        }
        .padding(.horizontal, 16)
    }
}
