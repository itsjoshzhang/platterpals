import SwiftUI

struct Order: View {
    
    @State private var items = MyGridItem.data
    @State private var reset = false
    @State private var showAction = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        let index = Int.random(in: 0...(items.count - 1))
        let food = items[index].imageName
        
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 16.0) {
                    
                    Divider()
                    Image(food)
                        .resizable()
                        .scaledToFit()
                    
                    HStack {
                        Text("Send Feedback: ")
                        Image(systemName: "heart")
                        Image(systemName: "message")
                        Image(systemName: "paperplane")
                    }
                    .foregroundColor(.secondary)
                    
                    BigButton(text: (food.uppercased()), route: "Feed")
                }
                .padding(.horizontal, 20.0)
                
                Button("Order with DoorDash") {
                    showAction = true
                }
                .buttonStyle(.borderedProminent)
                
                .navigationTitle("Found Your Food!")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("\(Image(systemName: "chevron.backward")) Back") {
                            reset = true
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $reset) {
                MyTabView()
            }
            .actionSheet(isPresented: $showAction) {
                ActionSheet(title: Text("Exit App"),
                    buttons: [
                        .default(Text("Log in to DoorDash")),
                        .cancel(Text("Cancel"))]
                )}}}}


struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Order()
    }
}
