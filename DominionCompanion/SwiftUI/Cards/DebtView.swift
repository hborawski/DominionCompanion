//
//  DebtView.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/30/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct DebtView: View {
    var value: Int
    var body: some View {
        Path { path in
            let dimension: CGFloat = 36.0
            let segmentLength = dimension / 2
            let short = cos(CGFloat(Double.pi/3)) * segmentLength // the short distance horizontally
            let tall = sin(CGFloat(Double.pi/3)) * segmentLength // the distance between the midpoint and the top/bottom lines
            let buffer = (dimension - (tall * 2)) / 2 // since this wont fill a square view, there is a buffer between the top of the view and the top line
            path.move(to: CGPoint(x: short, y: buffer))
            path.addLine(to: CGPoint(x: short + segmentLength, y: buffer))        // -
            path.addLine(to: CGPoint(x: dimension, y: buffer + tall))                 // \
            path.addLine(to: CGPoint(x: segmentLength + short, y: buffer + tall*2))   // /
            path.addLine(to: CGPoint(x: short, y: buffer + tall*2))                   // _
            path.addLine(to: CGPoint(x: 0, y: buffer + tall))                         // \
            path.addLine(to: CGPoint(x: short, y: buffer))
        }.foregroundColor(Color(UIColor(named: "Debt") ?? UIColor()))
        .overlay(Text("\(value)").foregroundColor(.black))
        .frame(width: 36, height: 36)
    }
}

struct DebtView_Previews: PreviewProvider {
    static var previews: some View {
        DebtView(value: 4)
    }
}
