// File: checked

import SwiftUI

struct Home: View {
    
    @State var showUpload = false
    @EnvironmentObject var DM: DataManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 16) {
                        BigButton(path: 1, text: "Let's order something!")
                            .environmentObject(DM)
                        
                        ForEach(DM.profiles) { profile in
                            Update(id: profile.id)
                                .environmentObject(DM)
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
struct Home_Previews: PreviewProvider {
	static var previews: some View {
        MyTabView()
            .environmentObject(DataManager())
	}
}
