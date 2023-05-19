import SwiftUI

struct NewOrder: View {

    // ## TRACK INFO ## \\
    @State var order = ""
    @State var place = ""
    @State var rating = 0
    @State var emoji = "🥡"
    @State var text: String

    // ## SETUP VIEW ## \\

    @State var error = false
    @FocusState var focus: Bool

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DM: DataManager

    var body: some View {
        NavigationStack {
        ZStack {
        Back()
        VStack() {

        // ## TEXTFIELDS ## \\

        if error {
            Text("AI reply error. Add order below.")
                .foregroundColor(.secondary)
                .font(.subheadline)}
        Group {
        HStack {
            Text("Menu item:")
            TextField("Add a menu item", text: $order)
        }
        HStack {
            Text("Restaurant:")
            TextField("Add a restaurant", text: $place)}}
        .textFieldStyle(.roundedBorder)
        .focused($focus)

        // ## STARS/EMOJI ## \\

        HStack {
            ForEach(1...5, id: \.self) { i in
                Image(systemName: (i <= rating ? "star.fill": "star"))
                    .resizable()
                    .foregroundColor(.pink)
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        rating = (rating == i ? 0: i)
                    }}}
        Text("Add ★ anytime.")
            .foregroundColor(.secondary)
            .font(.footnote)

        ScrollView(.horizontal) {
        LazyHGrid(rows: [GridItem(), GridItem()], spacing: 8) {
        ForEach(emojiList, id: \.self) { em in

        // ## CLICKABLES ## \\

        Button(em) { emoji = em }
        .background(emoji == em ? .pink: .white)
        .font(.system(size: 32))
        .cornerRadius(8)
        }}}
        .padding(8)
        .frame(height: 100)
        .border(.pink, width: 3)

        Text("Scroll for emojis!")
            .foregroundColor(.secondary)
            .font(.footnote)

        Button("Add to Orders") {
            DM.sendOrder(id: emoji + UUID().uuidString, user: DM.my().id,
                order: order, place: place, rating: rating, time: Date())
            dismiss()
        }
        .buttonStyle(.borderedProminent)
        .disabled(order.isEmpty || place.isEmpty)
        }
        .padding(.horizontal, 16)
        .navigationTitle("Add to Orders")

        // ## STRING LOGIC ## \\

        .onAppear {
            focus = true
            if let range = text.range(of: "##.*##",
                options: .regularExpression) {

                let trim = trimmed(String(text[range]))
                let list = trim.components(separatedBy: ";")
                order = trimmed(list[0])

                if list.count > 1 {
                    place = trimmed(list[1])
                }
            } else {
                error = true
            }}}}}

    func trimmed(_ text: String) -> String {
        return text.trimmingCharacters(in:
            CharacterSet(charactersIn: "# "))
    }
}
