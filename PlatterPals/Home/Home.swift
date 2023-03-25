// TODO: implementing profile search

import SwiftUI

struct Home: View {
    
    @State var showUpload = false
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 16) {

                        Text(DM.user().id)
                        Text(DM.user().name)
                        Search()
                        
                        BigButton(path: 1, text: "Let's order something!")
                            .environmentObject(DM)
                        
                        ForEach(DM.profiles) { profile in
                            if (DM.user().id != profile.id &&

                                DM.user().city == profile.city &&
                                DM.data().following.contains(profile.id)) {

                                Update(id: profile.id)
                                    .environmentObject(DM)
                            }
                        }
                    }
                }
                VStack { Spacer()
                    HStack { Spacer()
                        CircleButton(path: 2, image: "wand.and.stars")
                            .environmentObject(DM)
                    }
                }
            }
            .navigationTitle("PlatterPals")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        DM.initLoad()
                    } label: {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
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
}
struct Search: View {
    var body: some View {
        Text("Search feature")
    }
}

struct Home_Previews: PreviewProvider {
	static var previews: some View {
        MyTabView()
            .environmentObject(DataManager())
	}
}
