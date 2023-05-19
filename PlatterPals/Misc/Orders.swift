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
        List {
        ForEach(orderList) { od in

        VStack(alignment: .leading, spacing: 16) {
        Text(String(od.id.first ?? "🥡") + od.order)
        Text("Restaurant: \(od.place)")

        Rating(od: od)
            .environmentObject(DM)
            Text(od.time.formatted(.dateTime.day().month()))
        }}}
        .listStyle(.plain)
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

        if let order = try? doc.data(as: AIOrder.self) {
            if (order.user == user) {
                return order }}
        return nil
        }
        orderList.sort {
            $0.time < $1.time
        }}}}

struct Rating: View {

    @State var od: AIOrder
    @State var editing = false
    @EnvironmentObject var DM: DataManager

    var body: some View {
        HStack {
        Text("Rating:")
        ForEach(1...5, id: \.self) { i in

        Image(systemName: (i <= od.rating ? "star.fill": "star"))
            .foregroundColor(.pink)
            .onTapGesture {
                od.rating = (od.rating == i ? 0: i)
                editing = true
            }
        }
        Spacer()
        if editing {
            Button("Save Edits") {
                DM.sendOrder(id: od.id, user: od.user, order: od.order,
                    place: od.place, rating: od.rating, time: od.time)
                editing = false
            }}}}}
