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

    var pinned: Bool {
        setBuilder.pinnedLandscape.contains(card) || setBuilder.pinnedCards.contains(card)
    }

    var image: Image {
        Image(systemName: pinned ? "checkmark.circle.fill" : "checkmark.circle")
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

struct LargePinButton: View {
    @EnvironmentObject var setBuilder: SetBuilderModel

    var pinned: Bool {
        setBuilder.pinnedLandscape.contains(card) || setBuilder.pinnedCards.contains(card)
    }

    var image: Image {
        Image(systemName: pinned ? "xmark" : "checkmark")
    }

    var card: Card
    var body: some View {
        Group {
            if pinned {
                Button(action: { setBuilder.pin(card) }) {
                    HStack {
                        image
                        Text("Unpin")
                    }
                }
                .buttonStyle(SecondaryButtonStyle())
            } else {
                Button(action: { setBuilder.pin(card) }) {
                    HStack {
                        image
                        Text("Pin")
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
    }
}

extension View {
    @ViewBuilder
    func when<V: View>(_ condition: @autoclosure () -> Bool, apply: @escaping (Self) -> V) -> some View {
        Group {
            if condition() {
                apply(self)
            } else {
                self
            }
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(.white)
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 4).foregroundColor(.blue)
                    .opacity(configuration.isPressed ? 0.7 : 1.0)
            )
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(.blue)
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 4).stroke(lineWidth: 2).foregroundColor(.blue)
                    .opacity(configuration.isPressed ? 0.7 : 1.0)
            )
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

//struct PinButton_Previews: PreviewProvider {
//    static var previews: some View {
//        PinButton(card: "")
//    }
//}
