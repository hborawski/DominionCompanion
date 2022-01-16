//
//  SetBuilderView.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/30/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI
import Combine

struct SetBuilderView: View {
    @EnvironmentObject var setBuilder: SetBuilderModel
    @EnvironmentObject var toastModel: ToastModel
    
    @AppStorage(Constants.SaveKeys.settingsSortMode) var sortMode: SortMode = .cost
    
    @AppStorage(Constants.SaveKeys.settingsShowExpansionsWhenBuilding) var showExpansion: Bool = false

    @AppStorage(Constants.SaveKeys.settingsGameplayViewType) var gameplayStyle: GameplaySetupStyles = .list

    @AppStorage(Constants.SaveKeys.settingsSetBuilderViewType) var setBuilderStyle: SetBuilderStyles = .list
    
    @State var setup = false
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        setBuilder.shuffle()
                    }, label: {
                        Image(systemName: "shuffle")
                        Text("Shuffle")
                    }).frame(maxWidth: .infinity)
                    NavigationLink(destination: ExpansionSelection()) {
                        Image(systemName: "cube.box")
                        Text("Expansions")
                    }.frame(maxWidth: .infinity)
                    NavigationLink(destination: RulesView(ruleBuilder: setBuilder)) {
                        Image(systemName: "list.dash")
                        Text("Rules (\(setBuilder.rules.count))")
                    }.frame(maxWidth: .infinity)
                }
                .padding(.top, 10)
                setBuilderStyle.style.makeBody(SetBuilderConfiguration())
            }
            .navigationTitle("Set Builder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                    Button(action: {
                        self.setup.toggle()
                    }, label: {
                        Image(systemName: "play.fill")
                    })
                }
            }
            .background(
                NavigationLink(
                    destination: GameplaySetup(model: setBuilder.finalSet).environment(\.gameplaySetupStyle, gameplayStyle.style),
                    isActive: $setup,
                    label: {
                        EmptyView()
                    })
            )
        }
    }
}

struct SetBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        let cardData = CardData()
        let model = SetBuilderModel(cardData)
        model.pinnedCards = Array(cardData.cardsFromChosenExpansions.shuffled()[0...9])
        model.pinnedLandscape = [cardData.allEvents[0]]
        model.pinnedLandscape.append(cardData.allWays[0])
        return Group {
            SetBuilderView().preferredColorScheme(.light).environmentObject(model)
            SetBuilderView().preferredColorScheme(.dark).environmentObject(model)
        }
    }
}
