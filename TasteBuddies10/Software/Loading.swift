import SwiftUI

struct Loading: View {
    
    @State private var showSuggest = false
    @State private var size = 0.9
    @State private var opacity = 0.0
    @State private var progress = 0.0
    
    var timer = Timer.publish(
        every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Image("logo")
            Text("Taste Buddies")
                .font(.custom("pacifico", size: 48))
                .foregroundColor(.pink)
            
            Text("Loading the perfect dish...")
                .font(.headline)
                .foregroundColor(.pink)
            
            ProgressView(value: progress, total: 180)
                .padding()
                .background(.gray.opacity(0.25))
                .cornerRadius(8)
                .tint(.pink)
                .padding()
            
                .onReceive(timer) { _ in
                    if progress < 300 {
                        progress += 1
                    } else {
                        showSuggest = true
                    }
                }
        }
        .scaleEffect(size)
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeIn(duration: 1.0)) {
                self.size = 1.0
                self.opacity = 1.0
            }
        }
        .fullScreenCover(isPresented: $showSuggest) {
            Suggestion()
        }
    }
}
struct Suggestion: View {
    
    var items = MyGridItem.data
    @State private var reset = false
    
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
                
                Button("Order with DoorDash") {}
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
                Feed()
            }
        }
    }
}
struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Loading()
    }
}
