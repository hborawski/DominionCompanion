//
//  RuleRow.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/3/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct RuleRow<Builder: RuleBuilder>: View  where Builder: ObservableObject  {
    @ObservedObject var rule: Rule
    @ObservedObject var ruleBuilder: Builder
    var body: some View {
        HStack {
            HStack {
                Image("Card")
                Text(rule.operation.rawValue)
                Text("\(rule.value)")
            }
            Spacer()
            VStack {
                ForEach(rule.conditions, id: \.self) { condition in
                    HStack {
                        Text(condition.property.rawValue)
                        Text(condition.operation.rawValue)
                        Text(condition.comparisonValue)
                    }
                }
            }
        }
    }
}

struct RuleRow_Previews: PreviewProvider {
    static let rule = Rule(value: 2, operation: .greaterOrEqual, conditions: [
        Condition(property: .actions, operation: .greater, comparisonValue: "1"),
        Condition(property: .cards, operation: .equal, comparisonValue: "2")
    ])
    static var previews: some View {
        List {
            RuleRow(rule: rule, ruleBuilder: SetBuilderModel(CardData()))
        }
    }
}
