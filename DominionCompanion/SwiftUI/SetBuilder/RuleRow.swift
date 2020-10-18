//
//  RuleRow.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/3/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct RuleRow: View {
    var rule: SetRule
    var body: some View {
        HStack {
            HStack {
                Image("Card")
                Text(rule.operation.rawValue)
                Text("\(rule.value)")
            }
            Spacer()
            VStack {
                ForEach(rule.cardRules, id: \.self) { cardRule in
                    HStack {
                        Text(cardRule.property.rawValue)
                        Text(cardRule.operation.rawValue)
                        Text(cardRule.comparisonValue)
                    }
                }
            }
        }
    }
}

struct RuleRow_Previews: PreviewProvider {
    static let rule = SetRule(value: 2, operation: .greaterOrEqual, cardRules: [
        CardRule(property: .actions, operation: .greater, comparisonValue: "1"),
        CardRule(property: .cards, operation: .equal, comparisonValue: "2")
    ])
    static var previews: some View {
        List {
            RuleRow(rule: rule)
        }
    }
}
