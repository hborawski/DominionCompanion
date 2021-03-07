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
                Text("Glyph icons from icons8.com")
                Link("icons8.com", destination: URL(string: "https://icons8.com")!).foregroundColor(.blue)
            }
            Section(header: Text("Dominion")) {
                Text("Images and information available from http://wiki.dominionstrategy.com under \"Creative Commons Attribution Non-Commercial Share Alike\" license. This application is distributed under GPLv3 which is a compatible license.")
                Link("http://wiki.dominionstrategy.com", destination: URL(string: "http://wiki.dominionstrategy.com/")!).foregroundColor(.blue)
                Link("Creative Commons Attribution Non-Commercial Share Alike", destination: URL(string: "https://creativecommons.org/licenses/by-nc-sa/3.0/")!).foregroundColor(.blue)
                Link("GPLv3", destination: URL(string: "https://github.com/hborawski/DominionCompanion/blob/main/LICENSE")!).foregroundColor(.blue)
                Link("Compatible Licenses", destination: URL(string: "https://creativecommons.org/share-your-work/licensing-considerations/compatible-licenses")!).foregroundColor(.blue)
            }
        }.navigationTitle("Disclosures")
    }
}

struct Disclosures_Previews: PreviewProvider {
    static var previews: some View {
        Disclosures()
    }
}
