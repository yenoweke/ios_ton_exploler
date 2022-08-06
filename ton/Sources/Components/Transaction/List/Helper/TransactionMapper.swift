//
//  TransactionMapper.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 13.06.2022.
//

import Foundation

struct TransactionsMapper {
    static func map(
        _ items: [GetTransactionsResponse.Result],
        onTap: @escaping @MainActor (GetTransactionsResponse.Result) -> Void,
        filter: TransactionsFilter?,
        knownNames: KnownNamesStorage
    ) -> [TransactionListItemViewModel] {
        items.reduce(into: [TransactionListItemViewModel](), { partialResult, res in
            let onTap: @MainActor () -> Void = {
                onTap(res)
            }

            let outMsgs: [TransactionListItemViewModel] = res.outMsgs.compactMap { msg in
                if filter?.selectedMsgType == .onlyIn { return nil }
                
                if let filter = filter {
                    if self.isAmountInRange(msg.value.decimal, minValue: filter.minValue, maxValue: filter.maxValue) {
                        return TransactionListItemViewModel(msg: msg, incoming: false, utime: res.utime, knownNames: knownNames, onTap: onTap)
                    }
                    return nil
                }
                else {
                    return TransactionListItemViewModel(msg: msg, incoming: false, utime: res.utime, knownNames: knownNames, onTap: onTap)
                }
            }
            
            partialResult.append(contentsOf: outMsgs)
            if res.inMsg.source.isEmpty { return }

            if filter?.selectedMsgType == .onlyOut { return }
            
            if let filter = filter {
                if self.isAmountInRange(res.inMsg.value.decimal, minValue: filter.minValue, maxValue: filter.maxValue) {
                    let inMsg = TransactionListItemViewModel(msg: res.inMsg, incoming: true, utime: res.utime, knownNames: knownNames, onTap: onTap)
                    partialResult.append(inMsg)
                }
            }
            else {
                let inMsg = TransactionListItemViewModel(msg: res.inMsg, incoming: true, utime: res.utime, knownNames: knownNames, onTap: onTap)
                partialResult.append(inMsg)
            }
        })
    }
    
    private static func isAmountInRange(_ value: Decimal, minValue: Decimal?, maxValue: Decimal?) -> Bool {
        ((minValue ?? .zero)...(maxValue ?? Decimal.greatestFiniteMagnitude)).contains(value)
    }
}
//utime    Foundation.Date    2053-06-09 13:42:43 UTC
//hash    String    "jGsjZiA1bxhPAmRFdB50VAFU8SLYRwpowzGQyYFDyVw="
