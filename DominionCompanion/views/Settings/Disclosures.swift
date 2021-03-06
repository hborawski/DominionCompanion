//
//  Disclosures.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 3/6/21.
//  Copyright © 2021 Harris Borawski. All rights reserved.
//

import SwiftUI

struct Disclosures: View {
    var body: some View {
        List {
            Section(header: Text("Icons")) {
                HStack {
                    Text("Glyph icons from")
                    Link("icons8.com", destination: URL(string: "https://icons8.com")!)
                }
            }
        }.navigationTitle("Disclosures")
    }
}

struct Disclosures_Previews: PreviewProvider {
    static var previews: some View {
        Disclosures()
    }
}
