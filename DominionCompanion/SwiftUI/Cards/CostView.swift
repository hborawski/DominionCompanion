//
//  CostView.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/30/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct CostView: View {
    var value: Int
    var body: some View {
        Circle()
            .foregroundColor(Color(UIColor(named: "Treasure") ?? UIColor()))
            .overlay(Text("\(value)").foregroundColor(.black))
            .frame(width: 36)
    }
}

struct CostView_Previews: PreviewProvider {
    static var previews: some View {
        CostView(value: 4)
    }
}
