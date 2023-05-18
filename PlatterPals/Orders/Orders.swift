import SwiftUI

struct Orders: View {

    @State var binding = true
    @EnvironmentObject var DM: DataManager

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .sheet(isPresented: $binding) {
                NewOrder(text: "## some good ass food ; a good ass restaurant ##")
                    .environmentObject(DM)
            }
    }
}
