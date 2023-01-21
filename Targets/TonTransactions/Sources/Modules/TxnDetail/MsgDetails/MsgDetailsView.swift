import SwiftUI

struct MsgDetailsView: View {
    let vm: MsgDetailViewModel
    let onTapAddress: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(self.vm.direction)
                .font(AppFont.regular.textStyle(.body))
                .padding(
                    EdgeInsets(top: 4.0, leading: 16.0, bottom: 4.0, trailing: 16.0)
                )
                .background(
                    RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                        .fill(self.vm.incoming
                              ? AppColor.Palette.emerland.swiftUI.opacity(0.7)
                              : AppColor.Palette.alizarin.swiftUI.opacity(0.7)
                             )
                )
                .frame(maxWidth: .infinity, alignment: .leading)
            
            AddressDetailItemView(vm: self.vm.source)
                .fixedSize(horizontal: false, vertical: true)
                .onTapGesture { self.onTapAddress(self.vm.sourceAddress) }
            
            AddressDetailItemView(vm: self.vm.destination)
                .fixedSize(horizontal: false, vertical: true)
                .onTapGesture { self.onTapAddress(self.vm.destinationAddress) }
            
            AddressDetailItemView(vm: self.vm.value)
            AddressDetailItemView(vm: self.vm.forwardFee)
            AddressDetailItemView(vm: self.vm.ihrFee)
            AddressDetailItemView(vm: self.vm.creation)
            AddressDetailItemView(vm: self.vm.bodyHash)
            AddressDetailItemView(vm: self.vm.message)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                .fill(AppColor.Ton.background.swiftUI)
        )
    }
}

struct MsgDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MsgDetailsView(vm: .mock(), onTapAddress: { _ in })
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
