//
//  SavedRulesView.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 12/13/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct SavedRulesView: View {
    @EnvironmentObject var setBuilder: SetBuilderModel
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: SavedRuleSet.entity(), sortDescriptors: []) var savedRuleSets: FetchedResults<SavedRuleSet>
    
    @State var saveModal = false
    
    var body: some View {
        List {
            ForEach(savedRuleSets, id: \.self) { savedRuleSet in
                HStack {
                    Text(savedRuleSet.name)
                    Spacer()
                    Text("\(savedRuleSet.rules.count) rules").foregroundColor(.secondary)
                }
                .contextMenu {
                    Button(action: {
                        setBuilder.rules = savedRuleSet.decodedRules
                    }, label: {
                        Text("Replace Current Rules")
                    })
                    Button(action: {
                        setBuilder.rules = setBuilder.rules + savedRuleSet.decodedRules
                    }, label: {
                        Text("Append to Current Rules")
                    })
                }
            }
            .onDelete(perform: { indexSet in
                for index in indexSet {
                    managedObjectContext.delete(savedRuleSets[index])
                }
                do {
                    try managedObjectContext.save()
                } catch {}
            })
        }
        .alert(isPresented: $saveModal, TextAlert(title: "Save Current Rules", action: { saveName in
            guard let name = saveName else { return }
            do {
                let encoder = JSONEncoder()
                let rules: [String] = try setBuilder.rules.map { rule in
                    let ruleData = try encoder.encode(rule)
                    let stringRule = String(data: ruleData, encoding: .utf8)
                    return stringRule!
                }
                let savedSet = SavedRuleSet(context: managedObjectContext)
                savedSet.name = name
                savedSet.rules = rules
                try managedObjectContext.save()
            } catch(let error) {
                Logger.shared.e("\(error)")
            }
        }))
        .navigationBarItems(trailing: HStack {
            Button(action: {
                self.saveModal.toggle()
            }, label: {
                Text("Save")
            })
        })
        .navigationTitle(Text("Saved Rule Sets"))
    }
}

struct SavedRulesView_Previews: PreviewProvider {
    static var previews: some View {
        SavedRulesView()
    }
}
