import SwiftUI

struct NewOrder: View {

    // ## TRACK INFO ## \\
    @State var order = ""
    @State var place = ""
    @State var stars = 0
    @State var emoji = "🥡"
    @State var text: String

    // ## SETUP VIEW ## \\
    @State var error = false
    @FocusState var focus: Bool

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager

    var body: some View {
        NavigationStack {
        VStack {

        // ## TEXTFIELDS ## \\

        if error {
            Text("AI reply error. Add order below.")
                .foregroundColor(.secondary)
                .font(.subheadline)
        }
        Group {
            HStack {
                Text("Menu item:")
                TextField("Add a menu item", text: $order)
            }
            Max(count: 32, text: $order)
            HStack {
                Text("Restaurant:")
                TextField("Add a restaurant", text: $place)
            }
            Max(count: 32, text: $place)
        }
        .textFieldStyle(.roundedBorder)
        .submitLabel(.done)
        .focused($focus)

        // ## SHOW EMOJI ## \\

        ScrollView(.horizontal) {
        LazyHGrid(rows: [GridItem(), GridItem()], spacing: 8) {
        ForEach(emojiList, id: \.self) { em in

        Button(em) {
            emoji = em
        }
        .background(emoji == em ? .pink: .white)
        .font(.system(size: 32))
        .cornerRadius(8)
        }}}
        .padding(8)
        .frame(height: 100)
        .border(.pink, width: 3)

        // ## SHOW STARS ## \\

        Text("Scroll for emojis!")
            .foregroundColor(.secondary)
            .font(.subheadline)

        HStack {
        ForEach(1...5, id: \.self) { i in
            Image(systemName: (i <= stars ? "star.fill": "star"))
                .resizable()
                .foregroundColor(.pink)
                .frame(width: 24, height: 24)
                .onTapGesture {
                    stars = (stars == i ? 0: i)
                }}}
        Text("Add ★ anytime.")
            .foregroundColor(.secondary)
            .font(.subheadline)

        // ## ORDER LOGIC ## \\

        Button("Add Order") {
            var ord = AIOrder(user: DM.my().id, order: order, place:
                              place, stars: stars)

            ord.id = emoji + ord.id
            DM.sendOrder(ord: ord)
            dismiss()
        }
        .buttonStyle(.borderedProminent)
        .disabled(count(order) || count(place))
        }
        .padding(16)
        .navigationTitle("Add Order")
        .background {
            Back()
        }
        // ## HASHTAG CASE ## \\

        .onAppear {
        var list = [String]()

        if let range = text.range(of: "##.*##",
            options: .regularExpression) {

            let trim = trimmed(String(text[range]))
            list = trim.components(separatedBy: ";")

        // ## BULLET CASE ## \\

        } else if text.contains("-") {
            let comp = text.components(separatedBy: "-")
            list = comp.last?.components(separatedBy: ";") ?? list
        }
        if list.count == 2 {
            order = trimmed(list[0])
            place = trimmed(list[1])
        } else {
            error = true
        }}}}

    // ## FUNCTIONS ## \\

    func trimmed(_ text: String) -> String {
        return text.trimmingCharacters(in:
            CharacterSet(charactersIn: "# "))
    }
    func count(_ text: String) -> Bool {
        return (text.trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty || text.count > 32)
    }
}
