import SwiftUI

struct Home: View {

    @State var showUpload = false
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                Back()
                ScrollView {
                VStack(spacing: 16) {
                Search()
                    .environmentObject(DM)

                ForEach(DM.userList, id: \.self) { user in
                    let id = DM.my().id
                    let city = DM.my().city

                    if (id != user.id && city == user.city) {
                        Update(id: user.id, show: true)
                            .environmentObject(DM)
                }}}}
                .navigationTitle("PlatterPals")
                .toolbar {
                    ToolbarItem {
                        let up = Image(systemName: "square.and.arrow.up")

                        Button("\(up) Profile") {
                            showUpload = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .fullScreenCover(isPresented: $showUpload) {
                    Upload()
                        .environmentObject(DM)
                }}}}}

struct Search: View {
    @EnvironmentObject var DM: DataManager

    var body: some View {
        Text("")
    }
}
