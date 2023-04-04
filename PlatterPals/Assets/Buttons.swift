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
                if (showFollow) {
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
