//
//  SearchBar.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/30/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//


import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    @State var editing: Bool = false
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color(.systemGray6))
                .padding(8)
                .frame(minWidth: 10, idealWidth: 20, maxWidth: nil, minHeight: 20, idealHeight: 56, maxHeight: 56, alignment: .center)
                .overlay(HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(Color(.systemGray))
                        .padding(.leading, 16)
                    TextField("Search", text: $text).foregroundColor(.primary).onTapGesture {
                        self.editing = true
                    }.autocapitalization(.none).disableAutocorrection(true)
                    if !self.text.isEmpty {
                        Button(action: {
                            self.text = ""
                        }) {
                            Image(systemName: "xmark.circle.fill").foregroundColor(Color(.systemGray)).padding(.trailing, 16)
                        }
                    }
                })
                .animation(.spring())
            if editing {
                Button(action: {
                    self.editing = false
                    self.text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                }) {
                    Text("Cancel").foregroundColor(Color(.systemGray))
                }.padding(.trailing, 8)
            }
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SearchBar(text: .constant("Hello World"), editing: true)
            SearchBar(text: .constant(""))
        }
    }
}
