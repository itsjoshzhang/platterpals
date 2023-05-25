import SwiftUI
import FirebaseFirestoreSwift

struct Orders: View {

    @State var showOrder = false
    @State var showAlert = false
    @State var orders = [AIOrder]()
    @EnvironmentObject var DM: DataManager

    var body: some View {
        NavigationStack {
        if orders.isEmpty {
            NewOrder(text: "##;##")
        } else {

        VStack(spacing: 8) {
            Cards(id: DM.my().id)
                .environmentObject(DM)
                .padding(.top, 16)
        List {
        ForEach(orders) { ord in
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
            var data = DM.md()
            if data.favFoods.contains(ord.id) {

        Button("♥") {
            if let i = data.favFoods.firstIndex(of: ord.id) {
                data.favFoods.remove(at: i)
                DM.editData(data: data)

        }}} else {
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
        .listStyle(.plain)
        }
        .navigationTitle("My Orders")
        .background {
            Back()
        }
        .alert("3 favorite foods max.", isPresented: $showAlert) {
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
        }}}
        .onAppear {
            getOrder(user: DM.my().id)
        }
    }
    func getOrder(user: String) {
        FS.collection("aiOrders").addSnapshotListener { snap,_ in
        if let snap = snap {
        orders = snap.documents.compactMap { doc -> AIOrder? in

        if let ord = try? doc.data(as: AIOrder.self) {
            if (ord.user == user) {
                return ord }}
        return nil
        }
        orders.sort {
            $0.time > $1.time
        }}}}}

struct Cards: View {

    var id: String
    @State var orders = [AIOrder]()
    @EnvironmentObject var DM: DataManager

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            let data = DM.data(id: id)

        Text("My favorite foods: ")
            .font(.headline)

        if data.favFoods.isEmpty {
            Text("No favorites yet")
                .foregroundColor(.secondary)
                .frame(maxWidth: UIwidth-32)
        } else {
            TabView {
            ForEach(data.favFoods, id: \.self) { id in

            if let ord = orders.first { $0.id == id } {
                Card(ord: ord)
                    .environmentObject(DM)
            }}}
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            .frame(maxWidth: UIwidth-32, minHeight: 120, maxHeight: 120)
            .onAppear {
                getOrder(user: id)
            }}}}

    func getOrder(user: String) {
        FS.collection("aiOrders").addSnapshotListener { snap,_ in
        if let snap = snap {
        orders = snap.documents.compactMap { doc -> AIOrder? in

        if let ord = try? doc.data(as: AIOrder.self) {
            if (ord.user == user) {
                return ord }}
        return nil
        }
        orders.sort {
            $0.time < $1.time
        }}}}}

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
        HStack(spacing: 4) {
            Stars(button: false, ord: ord)
                .environmentObject(DM)
            Spacer()
            Text(ord.time.formatted(.dateTime.day().month()))
                .foregroundColor(.secondary)
        }
        }
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
