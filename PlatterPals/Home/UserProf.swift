import SwiftUI

struct UserProf: View {

    var id: String
    @State var image: UIImage?
    @State var showAction = false
    @State var showChatDM = false
    @State var showFollow = false

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
            let name = DM.user(id: id).name

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 16) {

                        RoundPic(image: image, width: 160)
                        
                        Text(name)
                    }
                    .padding(.horizontal, 20)
                    
                    HStack(spacing: 16) {
                        var users = DM.data(id: DM.my().id).favUsers

                        if users.contains(id) {
                            Button("Following") {

                                if let index = users.firstIndex(of: id) {
                                    users.remove(at: index)
                                }
                            }
                            .buttonStyle(.bordered)

                        } else {
                            Button("Follow \(Image(systemName: "heart"))") {
                                users.append(id)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        Button("\(Image(systemName: "bell"))") {
                            showAction = true
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Text("\(name)'s favorite foods:")
                        .font(.headline)
                        .padding(.horizontal, 20)
                }
            }
            .navigationTitle(name)
            .onAppear {
                getImage(id: id, path: "avatars")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
                ToolbarItem {
                    Button("Send chat") {
                        showChatDM = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .fullScreenCover(isPresented: $showChatDM) {
                Convo(id: id)
                    .environmentObject(DM)
            }
            .actionSheet(isPresented: $showAction) {
                ActionSheet(title: Text("Notifications"),
                    buttons: [
                        .destructive(Text("Block this user")),
                        .default(Text("Mute notifications")),
                        .cancel(Text("Cancel"))]
                )}}}

    func getImage(id: String, path: String) {
        let SR = SR.child("\(path)/\(id).jpg")

        SR.getData(maxSize: 8 * 1024 * 1024) { data, error in
            if let data = data {

                DispatchQueue.main.async {
                    image = UIImage(data: data)
                }}}}
}

struct UserProf_Previews: PreviewProvider {
	static var previews: some View {
        UserProf(id: "joshzhang@berkeley_edu")
            .environmentObject(DataManager())
	}
}
