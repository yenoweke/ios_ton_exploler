//
//  AddToWatchlistButton.swift
//  ton
//
//  Created by Dmitrii Chikovinskii on 22.06.2022.
//

import SwiftUI

struct AddToWatchlistButton: View {
    
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
    }
}

struct AddToWatchlistButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AddToWatchlistButton(added: true, onTap: {})
                .padding()
                .previewLayout(.sizeThatFits)
            
            AddToWatchlistButton(added: false, onTap: {})
                .padding()
                .previewLayout(.sizeThatFits)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
    
}
