// TODO: implement profile search

import SwiftUI

struct Home: View {

    @State var showUpload = false
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Search()
                        .environmentObject(DM)

                    ForEach(DM.userList, id: \.self) { user in
                        let id = DM.my().id
                        let favs = DM.data(id: id).favUsers

                        if (id != user.id && favs.contains(user.id)) {

                            Update(id: user.id)
                                .environmentObject(DM)
                        }
                    }
                }
            }
        }
        .navigationTitle("PlatterPals")
        .toolbar {
            ToolbarItem {
                Button("\(Image(systemName: "square.and.arrow.up")) Profile") {
                    showUpload = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .fullScreenCover(isPresented: $showUpload) {
            Upload()
                .environmentObject(DM)
        }
    }
}
struct Search: View {
    @EnvironmentObject var DM: DataManager

    var body: some View {
        VStack {

        }
    }
}
struct Home_Previews: PreviewProvider {
	static var previews: some View {
        MyTabView()
            .environmentObject(DataManager())
	}
}
