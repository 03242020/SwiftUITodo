//
//  CapsuleButtonStyle.swift
//  SwiftUITodo
//
//  Created by ryo.inomata on 2023/12/18.
//

import SwiftUI

struct CapsuleButtonStyle: ButtonStyle {
        
    @Environment(\.isEnabled) var isEnabled: Bool
    @State var show = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(self.isEnabled ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .font(.body.bold())
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.2), value: show)
    }
}
