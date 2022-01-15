//
//  PinButton.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 1/15/22.
//  Copyright © 2022 Harris Borawski. All rights reserved.
//

import SwiftUI

struct PinButton: View {
    @EnvironmentObject var setBuilder: SetBuilderModel

    var image: Image {
        Image(systemName: setBuilder.pinnedLandscape.contains(card) || setBuilder.pinnedCards.contains(card) ? "checkmark.circle.fill" : "checkmark.circle")
    }

    var card: Card
    var body: some View {
        Button(action: {
                setBuilder.pin(card)
        }, label: {
            image.foregroundColor(.blue)
        })
        .buttonStyle(PlainButtonStyle())
    }
}

//struct PinButton_Previews: PreviewProvider {
//    static var previews: some View {
//        PinButton(card: "")
//    }
//}
