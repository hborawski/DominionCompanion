//
//  ToastWrapper.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 2/27/21.
//  Copyright © 2021 Harris Borawski. All rights reserved.
//

import SwiftUI

class ToastModel: ObservableObject {
    @Published var showing: Bool = false
    @Published var message: String = ""

    func show(message: String, for seconds: Double = 1.5) {
        self.message = message
        self.showing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.showing = false
            self.message = ""
        }
    }
}
/**
 ViewModifier that wraps the content in a Toast Provider and environment object
 so any view in the hierarchy can request a toast
 */
struct Toasted: ViewModifier {
    @ObservedObject var toastModel = ToastModel()
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                content.environmentObject(toastModel).blur(radius: toastModel.showing ? 2 : 0)
                VStack {
                    Text(toastModel.message)
                }
                .frame(width: geometry.size.width * 0.67, height: geometry.size.height / 6)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .onTapGesture {
                    toastModel.showing = false
                }
                .opacity(toastModel.showing ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.3))
            }
        }
    }
}
