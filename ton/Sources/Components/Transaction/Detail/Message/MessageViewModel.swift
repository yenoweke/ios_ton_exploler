//
// Created by Dmitrii Chikovinskii on 10.06.2022.
//

import Foundation

struct MessageViewModel: Hashable {
    
    let incoming: Bool
    let direction: String
    let source: AddressDetailItemViewModel
    let destination: AddressDetailItemViewModel
    let value: AddressDetailItemViewModel
    let forwardFee: AddressDetailItemViewModel
    let ihrFee: AddressDetailItemViewModel
    let creation: AddressDetailItemViewModel
    let bodyHash: AddressDetailItemViewModel
    let message: AddressDetailItemViewModel
    let sourceAddress: String
    let destinationAddress: String

    init(msg: GetTransactionsResponse.Msg, incoming: Bool) {
        self.incoming = incoming
        self.direction = incoming ? L10n.Message.in : L10n.Message.out
        self.source = AddressDetailItemViewModel(
                title: L10n.Message.source,
                descr: msg.source.isEmpty ? L10n.Message.empty : msg.source,
                copy: !msg.source.isEmpty
        )
        self.sourceAddress = msg.source

        self.destination = AddressDetailItemViewModel(
                title: L10n.Message.destination,
                descr: msg.destination
        )
        self.destinationAddress = msg.destination

        self.value = AddressDetailItemViewModel(
                title: L10n.Message.value,
                descr: Formatters.ton.formatFull(msg.value),
                copy: false
        )
        self.forwardFee = AddressDetailItemViewModel(
                title: L10n.Message.forwardFee,
                descr: Formatters.ton.formatFull(msg.fwdFee),
                copy: false
        )
        self.ihrFee = AddressDetailItemViewModel(
                title: L10n.Message.ihrFee,
                descr: Formatters.ton.formatFull(msg.ihrFee),
                copy: false
        )
        self.creation = AddressDetailItemViewModel(
                title: L10n.Message.creationLT,
                descr: msg.createdLt
        )
        self.bodyHash = AddressDetailItemViewModel(
                title: L10n.Message.bodyHash,
                descr: msg.bodyHash
        )
        self.message = AddressDetailItemViewModel(
                title: L10n.Message.message,
                descr: msg.message
        )
    }
    
    init(incoming: Bool, source: AddressDetailItemViewModel, destination: AddressDetailItemViewModel, value: AddressDetailItemViewModel, forwardFee: AddressDetailItemViewModel, ihrFee: AddressDetailItemViewModel, creation: AddressDetailItemViewModel, bodyHash: AddressDetailItemViewModel, message: AddressDetailItemViewModel, sourceAddress: String, destinationAddress: String) {
        self.incoming = incoming
        self.direction = incoming ? L10n.Message.in : L10n.Message.out
        self.source = source
        self.destination = destination
        self.value = value
        self.forwardFee = forwardFee
        self.ihrFee = ihrFee
        self.creation = creation
        self.bodyHash = bodyHash
        self.message = message
        self.sourceAddress = sourceAddress
        self.destinationAddress = destinationAddress
    }

    static func mock() -> Self {
        MessageViewModel(
                incoming: false,
                source: AddressDetailItemViewModel(title: "Source", descr: "EQCtiv7PrMJImWiF2L5oJCgPnzp-VML2CAt5cbn1VsKAxLiE"),
                destination: AddressDetailItemViewModel(title: "Destination", descr: "EQCtiv7PrMJImWiF2L5oJCgPnzp-VML2CAt5cbn1VsKAxLiE"),
                value: AddressDetailItemViewModel(title: "Value", descr: "0.2 TON", copy: false),
                forwardFee: AddressDetailItemViewModel(title: "Forward fee", descr: "0.000666672 TON", copy: false),
                ihrFee: AddressDetailItemViewModel(title: "IHR fee", descr: "0 TON", copy: false),
                creation: AddressDetailItemViewModel(title: "Creation LT", descr: "28615968000002"),
                bodyHash: AddressDetailItemViewModel(title: "Body hash", descr: "YOkGhtAuqW6rTCRdkMg87EFcLn/JOROKWV7sBmC2AWY="),
                message: AddressDetailItemViewModel(title: "Message", descr: "2oA+/QAKAqHOORXXMBhqAA=="),
                sourceAddress: UUID().uuidString,
                destinationAddress: UUID().uuidString
        )
    }
}
