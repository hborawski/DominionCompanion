//
//  SetBuilderView.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/30/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct SetBuilderView: View {
    @EnvironmentObject var setBuilder: SetBuilderModel
    
    @AppStorage(Constants.SaveKeys.settingsSortMode) var sortMode: SortMode = .cost

    @ViewBuilder
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button("Shuffle") {
                        setBuilder.shuffle()
                    }.frame(maxWidth: .infinity)
                    NavigationLink(destination: ExpansionSelection()) {
                        Image(systemName: "cube.box")
                        Text("Expansions")
                    }.frame(maxWidth: .infinity)
                    NavigationLink(destination: RulesView()) {
                        Image(systemName: "list.dash")
                        Text("Rules (\(setBuilder.rules.count))")
                    }.frame(maxWidth: .infinity)
                }
                .padding(.top, 10)
                List {
                    Section(header: Text("Landscape Cards")) {
                        ForEach(setBuilder.landscape, id: \.name) { card in
                            let pinButton = Button(action: {setBuilder.pin(card)}, label: {
                                Image(systemName: setBuilder.pinnedLandscape.contains(card) ? "checkmark.circle.fill" : "checkmark.circle").foregroundColor(.blue)
                            }).buttonStyle(PlainButtonStyle())
                            NavigationLink(
                                destination: CardView(card: card) { pinButton },
                                label: {
                                    CardRow(card: card) {
                                        pinButton
                                    }
                                })
                                .buttonStyle(PlainButtonStyle())
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
                        }
                    }
                    Section(header: Text("Cards")) {
                        ForEach(setBuilder.cards.sorted(by: sortMode.sortFunction()), id: \.name) { card in
                            let pinButton = Button(action: {setBuilder.pin(card)}, label: {
                                Image(systemName: setBuilder.pinnedCards.contains(card) ? "checkmark.circle.fill" : "checkmark.circle").foregroundColor(.blue)
                            }).buttonStyle(PlainButtonStyle())
                            NavigationLink(
                                destination: CardView(card: card) { pinButton },
                                label: {
                                    CardRow(card: card) {
                                        pinButton
                                    }
                                })
                                .buttonStyle(PlainButtonStyle())
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
                        }
                    }
                }.listStyle(GroupedListStyle())
            }
            .navigationTitle("Set Builder")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SetBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        SetBuilderView().environmentObject(SetBuilderModel(CardData()))
    }
}
