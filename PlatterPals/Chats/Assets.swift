import SwiftUI

struct TitleBar: View {
    
    var id: String
    @State var image: UIImage?
    @State var showProf = false
    @State var showAlert = false
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Button {
                    showProf = true
                } label: {
                HStack(spacing: 16) {

                RoundPic(width: 160, image: image)

                VStack(alignment: .leading) {
                    let user = DM.user(id: id)
                    Text(user.name)
                        .font(.title).bold()

                    Text("\(user.city), CA")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Button("\(Image(systemName: "arrow.uturn.backward"))") {
                    dismiss()
                }
                Button("\(Image(systemName: "bell"))") {
                    showAlert = true
                }

            }
            .padding(.horizontal, 20)
            Div()
        }
        .onAppear {
            getImage(id: id, path: "avatars")
        }
        .fullScreenCover(isPresented: $showProf) {
            UserProf(id: id)
                .environmentObject(DM)
        }
        .confirmationDialog("", isPresented: $showAlert) {
            Button("Block this user") {
                var my = DM.data(id: DM.my().id)

                my.blocked.append(id)
                DM.editData(id: my.id, fo: my.favFoods, us: my.favUsers,
                            ch: my.chatting, bl: my.blocked)
            }}}

    func getImage(id: String, path: String) {
        let SR = SR.child("\(path)/\(id).jpg")

        SR.getData(maxSize: 8 * 1024 * 1024) { data, error in
            if let data = data {

                DispatchQueue.main.async {
                    image = UIImage(data: data)
                }}}}}

struct Bubble: View {
    
    var message: Message
    @State var showTime = false
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        let sender = (message.sender == DM.my().id)
        VStack(alignment: sender ? .trailing: .leading) {

            Text(message.text)
                .padding(16)
                .background(sender ? Color.pink.opacity(0.25): .secondary)
                .cornerRadius(30)

                .frame(maxWidth: 300, alignment: sender ? .trailing: .leading)
                .onTapGesture {
                    showTime.toggle()
                }
            if showTime {
                Text("\(message.time.formatted(.dateTime.hour().minute()))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 16)
            }
        }
        .padding(.horizontal, 16)
    }
}
