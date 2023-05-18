import SwiftUI

struct Orders: View {

    @State var binding = true
    @EnvironmentObject var DM: DataManager

    var body: some View {
        Text("♥")
            .sheet(isPresented: $binding) {
                NewOrder(text: "## some good ass food ; a good ass restaurant ##")
                    .environmentObject(DM)
            }
    }
}
