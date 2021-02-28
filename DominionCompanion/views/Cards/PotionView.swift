//
//  PotionView.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 1/31/21.
//  Copyright © 2021 Harris Borawski. All rights reserved.
//

import SwiftUI

struct PotionView: View {
    var value: Int
    let color = Color(UIColor(named: "Potion") ?? UIColor())
    var body: some View {
        ZStack {
            Circle().foregroundColor(color).frame(width: 28, height: 28).offset(x: 0, y: 4)
            Rectangle().foregroundColor(color).frame(width: 8, height: 12).offset(x: 0, y: -12)
            Text("\(value)").foregroundColor(.white).offset(x: 0, y: 3)
        }.frame(width: 36, height: 36)
    }
}

struct PotionView_Previews: PreviewProvider {
    static var previews: some View {
        PotionView(value: 2)
    }
}
