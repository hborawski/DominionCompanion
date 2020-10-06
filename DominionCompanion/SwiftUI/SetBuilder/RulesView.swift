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
    var body: some View {
        List {
            ForEach(setBuilder.rules, id: \.self) { rule in
                NavigationLink(destination: RuleView(rule: rule)) {
                    RuleRow(rule: rule)
                }
            }.onDelete(perform: { setBuilder.rules.remove(atOffsets: $0)})
        }
        .navigationTitle("Set Rules")
        .navigationBarItems(trailing: HStack {
            Button(action: {
                self.editing.toggle()
            }, label: {
                Image(systemName: "plus")
            })
        })
        .background(
            NavigationLink(
                destination: RuleView(),
                isActive: $editing,
                label: {
                    EmptyView()
                })
        )
    }
}

struct RulesView_Previews: PreviewProvider {
    static var previews: some View {
        RulesView()
    }
}
