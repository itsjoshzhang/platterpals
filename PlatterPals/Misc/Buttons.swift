import SwiftUI

struct ProfHead: View {

    var id: String
    @State var showFollow = false
    @EnvironmentObject var DM: DataManager

    var body: some View {
        HStack {
            let myID = DM.my().id
            var data = DM.data(id: myID)

            HStack {
                if showFollow {
                    Button("Following") {

                        if let i = data.favUsers.firstIndex(of: id) {
                            data.favUsers.remove(at: i)

                            editData(myID: myID, data: data)
                            showFollow = false
                        }
                    }
                    .buttonStyle(.bordered)

                } else {
                    Button("Follow \(Image(systemName: "heart"))") {
                        data.favUsers.append(id)

                        editData(myID: myID, data: data)
                        showFollow = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .onAppear {
                showFollow = data.favUsers.contains(id)
            }
        }
    }
    func editData(myID: String, data: UserData) {
        DM.editData(id: myID, fo: data.favFoods, us: data.favUsers,
                    ch: data.chatting, bl: data.blocked)
    }
}

struct Row: View {

    var id: String
    @State var image: UIImage?
    @EnvironmentObject var DM: DataManager

    var body: some View {
        HStack(spacing: 16) {
            let user = DM.user(id: id)

            RoundPic(image: image, width: 64)

            VStack(alignment: .leading, spacing: 8) {
                Text(user.name)
                    .font(.headline)

                Text("\(user.city), CA")
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            getImage(id: id, path: "avatars")
        }
    }
    func getImage(id: String, path: String) {
        let SR = SR.child("\(path)/\(id).jpg")

        SR.getData(maxSize: 8 * 1024 * 1024) { data, error in
            if let data = data {

                DispatchQueue.main.async {
                    image = UIImage(data: data)
                }}}}}
