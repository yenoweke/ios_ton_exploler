//
//  ErrorView.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 14.06.2022.
//

import SwiftUI
import TonTransactionsKit

struct ErrorViewModel {
    let title: String
    let description: String
    let retry: VoidClosure?
}

struct ErrorView: View {
    let title: String
    let description: String
    let retry: VoidClosure?
    
    var body: some View {
        VStack(alignment: .center, spacing: 16.0) {
            Text(self.title)
                .font(AppFont.bold.textStyle(.title2))
            
            Text(self.description)
                .font(AppFont.bold.textStyle(.caption))
                .fixedSize(horizontal: false, vertical: true)
                .frame(alignment: .center)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32.0)
            
            if let retry = retry {
                Button {
                    retry()
                } label: {
                    Text("Retry")
                }
                .buttonStyle(.bordered)

            }
        }
        .padding()
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(
            title: "Error",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi u",
            retry: {})
    }
}
