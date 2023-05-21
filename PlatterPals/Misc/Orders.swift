import SwiftUI
import FirebaseFirestoreSwift

struct Orders: View {

    @State var orderList = [AIOrder]()
    @State var showNewOd = false
    @EnvironmentObject var DM: DataManager

    var body: some View {
        NavigationStack {
        ZStack {
        Back()
        VStack {
        List {
        ForEach(orderList) { ord in

        VStack(alignment: .leading, spacing: 16) {
        Text(String(ord.id.first ?? "🥡") + ord.order)
        Text("Restaurant: \(ord.place)")

        Stars(ord: ord)
            .environmentObject(DM)
            Text(ord.time.formatted(.dateTime.day().month()))
        }}}
        .listStyle(.plain)
        // ## CARDS ## \\
              Cards()
        // ## CARDS ## \\
        }
        .padding(.top, 110)
        }
        .navigationTitle("My Orders")
        .onAppear {
            getOrder(user: DM.my().id)
        }
        .toolbar {
            ToolbarItem {
                Button("\(Image(systemName: "plus.app"))") {
                    showNewOd = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .sheet(isPresented: $showNewOd) {
            NewOrder(text: "##;##")
                .environmentObject(DM)
        }}}

    func getOrder(user: String) {
        FS.collection("aiOrders").addSnapshotListener { snap, error in
        orderList = snap!.documents.compactMap { doc -> AIOrder? in

        if let ord = try? doc.data(as: AIOrder.self) {
            if (ord.user == user) {
                return ord }}
        return nil
        }
        orderList.sort {
            $0.time < $1.time
        }}}}

struct Cards: View {
    @State var items = CardItem.data

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 16.0) {
                ForEach(items) { item in
                    Card(emoji: item.id, title: item.title, text: item.text)
                        .frame(width: UIwidth - 48.0)
                }
            }
            .padding(.horizontal, 20.0)
        }
        .frame(height: 160.0)
    }
}
struct Card: View {
    let emoji: String
    let title: String
    let text: String

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
            VStack(alignment: .leading, spacing: 8.0) {
                HStack(spacing: 16.0) {
                    Text(emoji)
                        .padding(16.0)
                        .background(.pink)
                        .clipShape(Circle())
                        .font(.system(size: 32))
                    Text(title)
                        .font(.headline)
                }
                Text(text)
                    .font(.caption)
            }
            .padding(16.0)
            Color(.secondarySystemFill)
                .cornerRadius(10.0)
        }
    }
}

struct Stars: View {

    @State var ord: AIOrder
    @State var editing = false
    @EnvironmentObject var DM: DataManager

    var body: some View {
        HStack {
        Text("Stars:")
        ForEach(1...5, id: \.self) { i in

        Image(systemName: (i <= ord.stars ? "star.fill": "star"))
            .foregroundColor(.pink)
            .onTapGesture {
                ord.stars = (ord.stars == i ? 0: i)
                editing = true
            }
        }
        Spacer()
        if editing {
            Button("Save Edits") {
                let ord = AIOrder(id: ord.id, user: ord.user, order:
                    ord.order, place: ord.place, stars: ord.stars,
                    time: ord.time)
                DM.sendOrder(ord: ord)
                editing = false
            }}}}}
