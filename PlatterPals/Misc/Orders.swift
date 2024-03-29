import SwiftUI
import FirebaseFirestoreSwift

class OrderManager: ObservableObject {
    @Published var orders = [AIOrder]()

    func getOrders(id: String) {
        FS.collection("aiOrders").addSnapshotListener { snap,_ in
        if let snap = snap {
        self.orders = snap.documents.compactMap { doc -> AIOrder? in

        if let ord = try? doc.data(as: AIOrder.self) {
            if ord.user == id {
                return ord }}
        return nil
        }
        self.orders.sort {
            $0.time > $1.time
        }}}}}

struct Orders: View {

    @State var page = ""
    @State var loading = true
    @State var showOrder = false
    @State var showAlert = false
    @Binding var pageDir: Int

    @StateObject var OM = OrderManager()
    @EnvironmentObject var DM: DataManager

    var body: some View {
        NavigationStack {
        ZStack {
            var data = DM.md()
            let noFood = OM.orders.isEmpty
            let noFavs = data.favFoods.isEmpty

        VStack(spacing: 8) {
            Cards(id: DM.my().id, page: $page)
                .environmentObject(DM)
                .environmentObject(OM)
                .padding(.top, 8)

        List {
        ForEach(OM.orders) { ord in
        VStack(spacing: 8) {
        HStack {

        VStack(alignment: .leading, spacing: 8) {
            Text("\(String(ord.id.first ?? "🥡")) \(ord.order)")
            Text(ord.place)
                .foregroundColor(.secondary)
        }
        .font(.headline)
        Spacer()

        Group {
        if let i = data.favFoods.firstIndex(of: ord.id) {
            Button("♥") {
                data.favFoods.remove(at: i)
                DM.editData(data: data)
            }
        } else {
            Button("♡") {
                if data.favFoods.count < 3 {
                    data.favFoods.append(ord.id)
                    DM.editData(data: data)
                } else {
                    showAlert = true
            }}}}
            .foregroundColor(.yellow)
            .font(.system(size: 24))
        }
        HStack {
            Stars(button: true, ord: ord)
                .environmentObject(DM)
            Spacer()
            Text(ord.time.formatted(.dateTime.day().month()))
                .foregroundColor(.secondary)
        }}}}
        .padding(.bottom, noFavs ? 70: 0)
        .opacity(noFood ? 0: 1)
        .listStyle(.plain)
        }
        .navigationTitle("My Orders")
        .background {
            Back()
        }
        .alert("Maximum of 3 favorite foods.", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        }
        .toolbar {
            ToolbarItem {
                Button("\(Image(systemName: "plus"))") {
                    showOrder = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .sheet(isPresented: $showOrder) {
            NewOrder(text: "##;##")
                .environmentObject(DM)
            }

        if noFood {
            VStack { Spacer(); Button {
                pageDir = 3
            } label: {
                Glow(text: "No orders yet? Ask your AI!")
        }}} else if noFavs {
            VStack { Spacer()
                Glow(text: "No favs yet? ♡ one above!")
            }}}}
        .onAppear {
            OM.getOrders(id: DM.my().id)
        }}}

struct Cards: View {

    var id: String
    @Binding var page: String
    @EnvironmentObject var DM: DataManager
    @EnvironmentObject var OM: OrderManager

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            let data = DM.data(id: id)

        if DM.user(id: id).rest {
            Text("\(spark) Restaurant favorites:")
                .foregroundColor(.pink)
                .font(.headline)
        } else {
            Text("My favorite foods:")
                .font(.headline)
        }
        if data.favFoods.isEmpty {
            let ord = AIOrder(id: "❔", user: "", order:
            "No favorites yet.", place: "Check back soon!", stars: -1)
            Card(ord: ord)
                .onAppear {
                    page = "nil!"
                }
        } else {
            TabView {
            ForEach(data.favFoods, id: \.self) { id in

            if let ord = OM.orders.first { $0.id == id } {
                Card(ord: ord)
            .environmentObject(DM)
            .onAppear {
                page = "\(ord.order) from \(ord.place)"
            }}}}
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
        }
        .frame(maxWidth: UIwidth - 32, minHeight: 140, maxHeight: 140)
        .onAppear {
            OM.getOrders(id: id)
        }}}

struct Card: View {

    var ord: AIOrder
    @EnvironmentObject var DM: DataManager

    var body: some View {
        VStack(spacing: 8) {
        HStack {
        Text(String(ord.id.first ?? "🥡"))
            .padding(8)
            .background(.pink)
            .clipShape(Circle())
            .font(.system(size: 32))

        VStack(alignment: .leading, spacing: 8) {
            Text(ord.order)
            Text(ord.place)
                .foregroundColor(.secondary)
        }
        .font(.headline)
        Spacer()
        }
        if ord.stars != -1 {
            HStack(spacing: 4) {
                Stars(button: false, ord: ord)
                    .environmentObject(DM)
                Spacer()
                Text(ord.time.formatted(.dateTime.day().month()))
                    .foregroundColor(.secondary)
            }}}
        .padding(16)
        .background(Color(red: 0.949, green: 0.949, blue: 0.969))
        .cornerRadius(8)
    }
}
struct Stars: View {

    var button: Bool
    @State var ord: AIOrder
    @EnvironmentObject var DM: DataManager

    var body: some View {
        HStack(spacing: 4) {
        ForEach(1...5, id: \.self) { i in

        Image(systemName: (i <= ord.stars ? "star.fill": "star"))
            .foregroundColor(.pink)
            .onTapGesture {
            if button {
                ord.stars = (ord.stars == i ? 0: i)
                DM.sendOrder(ord: ord)
            }}}}}}
