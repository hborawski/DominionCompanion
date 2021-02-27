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
                let saveButton = Button(action: {savedRuleSet.saveRules()}) {
                    Image(systemName: "checkmark.seal")
                }
                NavigationLink(destination: RulesView(ruleBuilder: savedRuleSet, toolbarItem: saveButton)) {
                    HStack {
                        Text(savedRuleSet.name)
                        Spacer()
                        Text("\(savedRuleSet.rules.count) rules").foregroundColor(.secondary)
                    }
                    .contextMenu {
                        Button(action: {
                            setBuilder.rules = savedRuleSet.rules
                        }, label: {
                            Text("Replace Current Rules")
                        })
                        Button(action: {
                            setBuilder.rules = setBuilder.rules + savedRuleSet.rules
                        }, label: {
                            Text("Append to Current Rules")
                        })
                    }
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
                let _ = SavedRuleSet(context: managedObjectContext).with(name: name, rules: setBuilder.rules)
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
