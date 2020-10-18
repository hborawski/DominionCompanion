//
//  NavigationCardRow.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/18/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct NavigationCardRow: View {
    @EnvironmentObject var setBuilder: SetBuilderModel
    
    var card: Card
    
    var showExpansion = false
    @ViewBuilder
    var body: some View {
        let pinButton = { c in
            Button(action: {setBuilder.pin(c)}, label: {
                Image(systemName: setBuilder.pinnedCards.contains(c) || setBuilder.pinnedLandscape.contains(c) ? "checkmark.circle.fill" : "checkmark.circle").foregroundColor(.blue)
            }).buttonStyle(PlainButtonStyle())
        }
        NavigationLink(
            destination: CardView(card: card, accessory: pinButton),
            label: {
                if self.showExpansion {
                    CardRow(card: card) {
                        HStack {
                            Text(card.expansion).foregroundColor(.gray)
                            pinButton(card)
                        }
                    }
                } else {
                    CardRow(card: card) { pinButton(card) }
                }
            })
            .buttonStyle(PlainButtonStyle())
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
    }
}

//struct NavigationCardRow_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationCardRow()
//    }
//}
