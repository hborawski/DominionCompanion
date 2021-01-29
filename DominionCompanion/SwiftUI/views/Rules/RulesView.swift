//
//  RulesView.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/3/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct RulesView: View {
    @EnvironmentObject var setBuilder: SetBuilderModel

    @State var editing = false
    @State var savedRules = false
    var body: some View {
        List {
            ForEach(setBuilder.rules, id: \.self) { rule in
                NavigationLink(destination: RuleView(existing: rule)) {
                    RuleRow(rule: rule)
                }
            }.onDelete(perform: { setBuilder.rules.remove(atOffsets: $0)})
        }
        .navigationTitle("Set Rules")
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                Button(action: {
                    self.savedRules.toggle()
                }, label: {
                    Image(systemName: "list.dash")
                })
            }
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                Button(action: {
                    self.editing.toggle()
                }, label: {
                    Image(systemName: "plus")
                })
            }
        }
        .background(
            NavigationLink(
                destination: RuleView(),
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
            SetRule(value: 2, operation: .greater, cardRules: [
                CardRule(property: .actions, operation: .equal, comparisonValue: "2")
            ])
        ]
        return NavigationView {
            RulesView().environmentObject(model)
        }
    }
}
