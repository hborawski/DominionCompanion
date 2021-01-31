//
//  ConditionRow.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/3/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct ConditionRow: View {
    @ObservedObject var condition: Condition
    
    var onDelete: (() -> Void)?
    
    @EnvironmentObject var cardData: CardData

    @ViewBuilder
    var body: some View {
        Picker("Property", selection: $condition.property) {
            ForEach(cardData.allAttributes, id: \.self) { attr in
                Text(attr.rawValue)
            }
        }
        Picker("Operator", selection: $condition.operation) {
            ForEach(condition.property.inputType.availableOperations, id: \.self) { operation in
                Text(operation.rawValue)
            }
        }
        Picker("Value", selection: $condition.comparisonValue) {
            ForEach(condition.property.all, id: \.self) { value in
                Text(value)
            }
        }
        if onDelete != nil {
            Button("Delete") { self.onDelete?() }
        }
    }
}

struct ConditionRow_Previews: PreviewProvider {
    static let defaultRule = Condition(property: .cost, operation: .greater, comparisonValue: "0")
    @ObservedObject static var rule: Rule = Rule(value: 0, operation: .greater, conditions: [defaultRule])
    static var previews: some View {
        Form {
            ConditionRow(condition: defaultRule)
        }
    }
}
