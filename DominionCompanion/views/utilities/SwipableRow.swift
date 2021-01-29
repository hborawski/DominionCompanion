//
//  SwipableRow.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/18/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct SwipableRow<Content>: View where Content: View {
    typealias SwipeAction = (Int, Image, Color, () -> Void)
    enum SwipeDirection {
        case leading
        case trailing
    }
    var direction: SwipeDirection = .trailing
    var actions: [SwipeAction] = []
    var content: () -> Content
    
    var maxDistance: CGFloat { itemWidth * CGFloat(actions.count) }
    
    var bounceDistance: CGFloat = 30.0
    
    var itemWidth = CGFloat(60)
    
    @State private var offset: CGFloat = 0.0
    @ViewBuilder
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                if direction == .leading {
                }
                Spacer()
                if direction == .trailing {
                    ForEach(actions.reversed(), id: \.0) { action in
                        Button(action: {
                            action.3()
                            self.offset = 0.0
                        }, label: {
                            action.1
                                .fixedSize(horizontal: true, vertical: false)
                                .frame(maxHeight: .infinity)
                                .frame(width: self.itemWidth)
                                .background(action.2)
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }.frame(maxHeight: .infinity)
            .background(actions.last?.2 ?? Color.clear)
            content()
            .gesture(
                DragGesture(minimumDistance: 30, coordinateSpace: .local)
                    .onChanged(self.handleDragChanged(_:))
                    .onEnded(self.handleDragEnd(_:))
            )
            .animation(.spring())
            .offset(x: offset, y: 0)
            .onAppear {
                self.offset = 0.0
            }
        }
    }
    
    func handleDragChanged(_ value: DragGesture.Value) {
        let width = value.translation.width
        switch self.direction {
        case .leading:
            if width > 0, width <= maxDistance + self.bounceDistance + 1 {
                self.offset = width
            }
        case .trailing:
            if width < 0, width >= -maxDistance - self.bounceDistance - 1 {
                self.offset = width
            } else if width > 0, self.offset != 0.0 {
                self.offset = 0.0
            }
        }
    }
    
    func handleDragEnd(_ value: DragGesture.Value) {
        switch self.direction {
        case .leading:
            guard self.offset > self.itemWidth else {
                self.offset = 0.0
                return
            }
            guard self.offset <= (self.maxDistance + self.bounceDistance) else {
                self.offset = 0.0
                return
            }
            self.offset = self.maxDistance
        case .trailing:
            guard self.offset < -self.itemWidth else {
                self.offset = 0.0
                return
            }
            guard self.offset >= (-self.maxDistance - self.bounceDistance) else {
                self.offset = 0.0
                return
            }
            self.offset = -self.maxDistance
        }
    }
}

struct SwipableRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SwipableRow(actions: [], content: {Text("Hello World")})
        }
    }
}
