//
//  CardRuleRow.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/3/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct CardRuleRow: View {
    @Binding var property: CardProperty
    
    @Binding var operation: FilterOperation
    
    @Binding var value: String
    
    var onDelete: (() -> Void)?
    
    @EnvironmentObject var cardData: CardData

    @ViewBuilder
    var body: some View {
        Picker("Property", selection: $property) {
            ForEach(cardData.allAttributes, id: \.self) { attr in
                Text(attr.rawValue)
            }
        }
        Picker("Operator", selection: $operation) {
            ForEach(property.inputType.availableOperations, id: \.self) { operation in
                Text(operation.rawValue)
            }
        }
        Picker("Value", selection: $value) {
            ForEach(property.all, id: \.self) { value in
                Text(value)
            }
        }
        if onDelete != nil {
            Button("Delete") { self.onDelete?() }
        }
    }
}

struct CardRuleRow_Previews: PreviewProvider {
    static let defaultRule = CardRule(property: .cost, operation: .greater, comparisonValue: "0")
    @ObservedObject static var rule: SetRule = SetRule(value: 0, operation: .greater, cardRules: [defaultRule])
    static var previews: some View {
        Form {
            CardRuleRow(property: $rule.cardRules[0].property, operation: $rule.cardRules[0].operation, value: $rule.cardRules[0].comparisonValue).environmentObject(CardData())
        }
    }
}
