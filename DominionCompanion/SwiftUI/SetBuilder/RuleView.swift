//
//  RuleView.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/3/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct RuleView: View {
    static let defaultRule = CardRule(property: .cost, operation: .greater, comparisonValue: "0")
    
    @ObservedObject var rule: SetRule = SetRule(value: 0, operation: .greater, cardRules: [RuleView.defaultRule])


    var matchingCards: [Card] {
        get {
            return rule.cardRules.reduce(cardData.cardsFromChosenExpansions) { (cards, rule) -> [Card] in
                let cardSet = Set(cards)
                let matchingFilter = Set(cardData.cardsFromChosenExpansions.filter { rule.matches(card: $0) })
                return Array(cardSet.intersection(matchingFilter))
            }
        }
    }

    
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
                Picker("Operation", selection: $rule.operation) {
                    ForEach(RuleType.number.availableOperations, id: \.self) { operation in
                        Text(operation.rawValue)
                    }
                }
                Picker("Number Of Cards", selection: $rule.value) {
                    ForEach(Array(0...11), id: \.self) { number in
                        Text("\(number)")
                    }
                }
            }
            Section(header: Text("Conditions")) {
                Button("Add Condition") {
                    rule.cardRules.append(CardRule(property: .cost, operation: .greater, comparisonValue: "0"))
                }
            }
            
            ForEach(Array(zip(rule.cardRules.indices, rule.cardRules)), id: \.1.id) { index, rule in
                Section {
                    CardRuleRow(
                        property: $rule.cardRules[index].property,
                        operation: $rule.cardRules[index].operation,
                        value: $rule.cardRules[index].comparisonValue,
                        onDelete: self.rule.cardRules.count > 1 ?
                        {
                            self.rule.cardRules.remove(at: index)
                        }:
                        nil
                    )
                }
            }
        }
        .navigationBarItems(trailing: HStack {
            Button("Save") {
                if let index = setBuilder.rules.firstIndex(where: {$0.id == self.rule.id}) {
                    setBuilder.rules[index] = rule
                } else {
                    setBuilder.rules.append(rule)
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
