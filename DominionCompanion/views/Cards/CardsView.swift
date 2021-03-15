//
//  CardsView.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/30/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct CardsView<T>: View where T: View {
    @EnvironmentObject var setBuilder: SetBuilderModel

    var cards: [Card]
    
    var title: String?
    
    var accessory: (Card) -> T = { _ in EmptyView() as! T }
    
    var showOnRow: Bool = false
    
    @State var searchText: String = ""

    @State var advancedFilter: Bool = false

    @ObservedObject var cardFilter = CardFilter()
    
    @ViewBuilder
    var body: some View {
        List {
            HStack {
                SearchBar(text: $searchText)
                Button(action: {
                    self.advancedFilter.toggle()
                }, label: {
                    self.advancedFilter ?
                        Image(systemName: "line.horizontal.3.decrease.circle.fill") :
                    Image(systemName: "line.horizontal.3.decrease.circle")
                }).buttonStyle(PlainButtonStyle()).foregroundColor(.blue)
            }
            if advancedFilter {
                NavigationLink(
                    destination: RuleView(ruleBuilder: cardFilter, existing: cardFilter.rule, matchSet: false),
                    label: {
                        HStack {
                            Text("Advanced Filter:")
                            Spacer()
                            VStack {
                                ForEach(cardFilter.rule.conditions, id: \.self) { condition in
                                    HStack {
                                        Text(condition.property.rawValue)
                                        Text(condition.operation.rawValue)
                                        Text(condition.comparisonValue)
                                    }
                                }
                            }
                        }
                    })
            }
            ForEach(filterCards(cards), id: \.id) { card in
                NavigationLink(
                    destination: CardView(card: card, accessory: self.accessory)
                ) {
                    if self.showOnRow {
                        CardRow(card: card) { self.accessory(card) }
                    } else {
                        CardRow(card: card) { EmptyView() }
                    }
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
            }
        }
        .navigationTitle(Text(title ?? "All Cards"))
    }

    func filterCards(_ cards: [Card]) -> [Card] {
        if advancedFilter {
            return cardFilter.rule.matchingCards(cards).filter({ searchText != "" ? $0.name.lowercased().contains(searchText) : true})
        } else {
            return cards
                .filter({ searchText != "" ? $0.name.lowercased().contains(searchText) : true})
        }
    }
}

struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        let cardData = CardData()
        return NavigationView {
            CardsView<EmptyView>(cards: cardData.allCards)
        }
    }
}
