import SwiftUI

struct Suggest2: View {

    @EnvironmentObject var DM: DataManager
    @StateObject var VM = ViewModel(api: ChatGPTAPI())
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
