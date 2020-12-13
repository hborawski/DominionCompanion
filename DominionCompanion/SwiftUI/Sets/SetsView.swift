//
//  SetsView.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 12/12/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct SetsView: View {    
    @State var searchText: String = ""
    @State var setType = 0
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBar(text: $searchText)
                Picker(selection: $setType, label: EmptyView()) {
                    Text("Recommended").tag(0)
                    Text("Saved").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
                if setType == 0 {
                    RecommendedSetsView(searchText: $searchText).listStyle(GroupedListStyle())
                } else {
                    SavedSetsView(searchText: $searchText).listStyle(GroupedListStyle())
                }
            }.navigationTitle(Text("\(setType == 0 ? "Recommended" : "Saved") Sets"))
        }
    }
}

struct SetsView_Previews: PreviewProvider {
    static var previews: some View {
        SetsView()
    }
}
