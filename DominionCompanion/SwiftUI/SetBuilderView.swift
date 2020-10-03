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
    
    @State var selectExpansions = false
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button("Shuffle") {
                        setBuilder.getSet()
                    }
                    Button("Expansions") {
                        self.selectExpansions.toggle()
                    }
                    Button("Rules") {
                        
                    }
                }
                List {
                    Section(header: Text("Cards")) {
                        ForEach(setBuilder.currentSet, id: \.name) { card in
                            CardRow(card: card).listRowInsets(EdgeInsets())
                        }.onDelete(perform: { indexSet in
                            print(indexSet)
                        })
                    }
                }.listStyle(GroupedListStyle())
            }
            .navigationTitle("Set Builder")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $selectExpansions, content: {
                ExpansionSelection(show: $selectExpansions)
            })
        }
    }
}

struct SetBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        SetBuilderView()
    }
}
