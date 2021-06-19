//
//  RulesView.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/3/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct RulesView<Builder: RuleBuilder>: View where Builder: ObservableObject {
    @ObservedObject var ruleBuilder: Builder

    var toolbarItem: Button<Image>? = nil

    @State var editing = false
    @State var savedRules = false
    @ViewBuilder
    var body: some View {
        List {
            ForEach(ruleBuilder.rules, id: \.self) { rule in
                NavigationLink(destination: RuleView(ruleBuilder: ruleBuilder, existing: rule).navigationTitle("Rule Edit")) {
                    RuleRow(rule: rule, ruleBuilder: ruleBuilder)
                }
            }.onDelete(perform: { ruleBuilder.removeRule($0) })
        }
        .navigationTitle("Set Rules")
        .navigationBarItems(trailing: HStack {
            if let button = toolbarItem {
                button
            } else {
                Button(action: {
                    self.savedRules.toggle()
                }, label: {
                    Image(systemName: "list.dash")
                })
            }
            Button(action: {
                self.editing.toggle()
            }, label: {
                Image(systemName: "plus")
            })
        })
        .background(
            NavigationLink(
                destination: RuleView(ruleBuilder: ruleBuilder).navigationTitle("Rule Creation"),
                isActive: $editing,
                label: {
                    EmptyView()
                })
        )
        .background(
            NavigationLink(
                destination: SavedRulesView(),
                isActive: $savedRules,
                label: {
                    EmptyView()
                })
        )
    }
}

struct RulesView_Previews: PreviewProvider {
    static var previews: some View {
        let cardData = CardData()
        let model = SetBuilderModel(cardData)
        model.rules = [
            Rule(value: 2, operation: .greater, conditions: [
                Condition(property: .actions, operation: .equal, comparisonValue: "2")
            ])
        ]
        return NavigationView {
            RulesView(ruleBuilder: model)
        }
    }
}
