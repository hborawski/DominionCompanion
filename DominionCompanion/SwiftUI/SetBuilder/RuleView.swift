//
//  RuleView.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/3/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct RuleView: View {
    var rule: SetRule?
    
    init(rule: SetRule? = nil) {
        self.rule = rule
        _setOperation = State(initialValue: rule?.operation ?? .greater)
        _setCards = State(initialValue: rule?.value ?? 0)
        _rules = State(initialValue: rule?.cardRules ?? [])
    }

    var currentRule: SetRule { SetRule(value: setCards, operation: setOperation, cardRules: rules) }
    
    var matchingCards: [Card] {
        get {
            return rules.reduce(CardData.shared.cardsFromChosenExpansions) { (cards, rule) -> [Card] in
                let cardSet = Set(cards)
                let matchingFilter = Set(CardData.shared.cardsFromChosenExpansions.filter { rule.matches(card: $0) })
                return Array(cardSet.intersection(matchingFilter))
            }
        }
    }

    @State var setOperation: FilterOperation
    @State var setCards: Int
    @State var rules: [CardRule]
    
    @EnvironmentObject var cardData: CardData
    
    @EnvironmentObject var setBuilder: SetBuilderModel
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        return Form {
            Section(header: Text("Matching Cards")) {
                NavigationLink(destination: CardsView(cards: matchingCards)) {
                    Text("\(matchingCards.count)")
                }
            }
            Section(header: HStack {
                Image("Card")
                Text("Cards to match in set")
            }) {
                Picker("Operation", selection: $setOperation) {
                    ForEach(RuleType.number.availableOperations, id: \.self) { operation in
                        Text(operation.rawValue)
                    }
                }
                Picker("Number Of Cards", selection: $setCards) {
                    ForEach(Array(0...11), id: \.self) { number in
                        Text("\(number)")
                    }
                }
            }
            Section(header: Text("Conditions")) {
                Button("Add Condition") {
                    rules.append(CardRule(type: .number, property: .cost, operation: .greater, comparisonValue: "0"))
                }
            }
            
            ForEach(rules.indices, id: \.self) { rule in
                Section {
                    CardRuleRow(rule: $rules[rule])
                }
            }
        }
        .navigationBarItems(trailing: HStack {
            Button("Save") {
                if let existing = rule, let index = setBuilder.rules.firstIndex(of: existing) {
                    setBuilder.rules[index] = currentRule
                } else {
                    setBuilder.rules.append(currentRule)
                }
                self.presentationMode.wrappedValue.dismiss()
            }
        })
    }
}

//struct RuleView_Previews: PreviewProvider {
//    static var previews: some View {
//        RuleView()
//    }
//}
