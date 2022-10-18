import SwiftUI

struct AddToWatchlistView: View {

    let added: Bool
    let onTap: VoidClosure

    var body: some View {
        Button {
            self.onTap()
        } label: {
            Image(systemName: self.added ? "star.fill" : "star")
                    .conditional(self.added) { view in
                        view
                                .renderingMode(.template)
                                .foregroundColor(Color.yellow)
                    }
        }
        .font(Fonts.Mulish.regular.textStyle(.body))
    }
}

struct AddToWatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        AddToWatchlistView(added: false, onTap: { })
    }
}
