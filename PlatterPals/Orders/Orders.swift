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
        VStack {
            Text(String(od.id.first ?? "🥡") + od.order)
            Text("Restaurant: \(od.place)")
            Text("Rating: \(od.rating)")
            Text(od.time.formatted())
        }}}
        .listStyle(.plain)
        .padding(.top, 100)
        }
        .navigationTitle("My Orders")
        .onAppear {
            getOrder(user: DM.my().id)
        }
        .toolbar {
            ToolbarItem {
                Button("+") {
                    showNewOd = true
                }}}
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
