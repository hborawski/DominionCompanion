//
//  CardRuleRow.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/3/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct CardRuleRow: View {
    @Binding var rule: CardRule
    
    @EnvironmentObject var cardData: CardData

    var body: some View {
            Picker("Property", selection: $rule.property) {
                ForEach(cardData.allAttributes, id: \.self) { attr in
                    Text(attr.rawValue)
                }
            }
            Picker("Operator", selection: $rule.operation) {
                ForEach(rule.property.inputType.availableOperations, id: \.self) { operation in
                    Text(operation.rawValue)
                }
            }
            Picker("Value", selection: $rule.comparisonValue) {
                ForEach(rule.property.all, id: \.self) { value in
                    Text(value)
                }
            }
        }
}

//struct CardRuleRow_Previews: PreviewProvider {
//    static var previews: some View {
//        CardRuleRow()
//    }
//}
