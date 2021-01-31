//
//  RuleView.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/3/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct RuleView: View {
    static let defaultRule = Condition(property: .cost, operation: .greater, comparisonValue: "0")
    
    var existing: Rule?
    
    var rule: Rule {
        Rule(value: 0, operation: .greater, conditions: conditions)
    }


    var matchingCards: [Card] {
        get {
            return rule.conditions.reduce(cardData.cardsFromChosenExpansions) { (cards, rule) -> [Card] in
                let cardSet = Set(cards)
                let matchingFilter = Set(cardData.cardsFromChosenExpansions.filter { rule.matches(card: $0) })
                return Array(cardSet.intersection(matchingFilter))
            }
        }
    }
    
    @State var operation: FilterOperation = .greaterOrEqual
    
    @State var value: Int = 0
    
    @State var conditions: [Condition] = [Condition(property: .cost, operation: .greater, comparisonValue: "0")]
    
    @State var id: UUID? = nil

    
    @EnvironmentObject var cardData: CardData
    
    @EnvironmentObject var setBuilder: SetBuilderModel
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        return Form {
            Section(header: Text("Matching Cards")) {
                NavigationLink(destination: CardsView<EmptyView>(cards: matchingCards)) {
                    Text("\(matchingCards.count)")
                }
            }
            Section(header: HStack {
                Image("Card")
                Text("Cards to match in set")
            }) {
                Picker("Operation", selection: $operation) {
                    ForEach(RuleType.number.availableOperations, id: \.self) { operation in
                        Text(operation.rawValue)
                    }
                }
                Picker("Number Of Cards", selection: $value) {
                    ForEach(Array(0...11), id: \.self) { number in
                        Text("\(number)")
                    }
                }
            }
            Section(header: Text("Conditions")) {
                Button("Add Condition") {
                    conditions.append(Condition(property: .cost, operation: .greater, comparisonValue: "0"))
                }
            }
            ForEach(conditions, id: \.id) { condition in
                Section {
                    ConditionRow(
                        rule: condition,
                        onDelete: self.conditions.count > 1 ?
                        {
                            self.conditions = self.conditions.filter { $0.id != condition.id }
                        }:
                        nil
                    )
                }
            }
        }
        .navigationBarItems(trailing: HStack {
            Button("Save") {
                let newRule = Rule(value: value, operation: operation, conditions: conditions)
                if let index = setBuilder.rules.firstIndex(where: {$0.id == self.id}) {
                    setBuilder.rules[index] = newRule
                } else {
                    setBuilder.rules.append(newRule)
                }
                self.presentationMode.wrappedValue.dismiss()
            }
        })
        .onAppear {
            if let existingRule = existing, id == nil {
                operation = existingRule.operation
                value = existingRule.value
                conditions = existingRule.conditions
                id = existingRule.id
            }
        }
    }
}

struct RuleView_Previews: PreviewProvider {
    static var previews: some View {
        let cardData = CardData()
        let model = SetBuilderModel(cardData)
        return RuleView().environmentObject(cardData).environmentObject(model)
    }
}
