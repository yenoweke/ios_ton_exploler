import SwiftUI

struct AddressDetailItemView: View {
    let vm: AddressDetailItemViewModel
    
    var textStyle: SwiftUI.Font.TextStyle = .body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            Text(self.vm.title)
                .font(AppFont.regular.textStyle(.caption2))
            
            Text(self.vm.descr)
                .padding(4.0)
                .font(AppFont.regular.textStyle(self.textStyle))
                .conditional(self.vm.copy) { view in
                    view
                        .contextCopy(text: self.vm.descr)
                        .foregroundColor(AppColor.Ton.main.swiftUI)
                }
        }
    }
}

struct AddressDetailItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddressDetailItemView(
            vm: AddressDetailItemViewModel(
                title: "Source",
                descr: "EQasjd91_Sda2fjsd"
            )
        )
    }
}
