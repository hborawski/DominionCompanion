//
//  ListChoice.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/30/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI


struct ListChoice: View {
    var title: String
    var value: String
    var values: [String] = []
    var onTap: (String) -> Void
    
    @State var showing = false
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
        }
        .contentShape(Rectangle())
        .onTapGesture(count: 1, perform: {
            self.showing.toggle()
        })
        .actionSheet(isPresented: $showing, content: {
            ActionSheet(
                title: Text("Edit Value"),
                buttons: values.map { title in
                    ActionSheet.Button.default(
                        Text(title), action: {
                            self.onTap(title)
                        }
                    )
                } +
                [ActionSheet.Button.cancel()]
            )
        })
    }
}

struct ListChoice_Previews: PreviewProvider {
    static var previews: some View {
        ListChoice(title: "Test", value: "1", values: ["0", "1", "2"]) {_ in}
    }
}
