//
//  FloadtingButtonView.swift
//  SwiftUITodo
//
//  Created by ryo.inomata on 2023/11/27.
//

import SwiftUI

struct RoundedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 68, height: 44)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.blue, lineWidth: 2)
            )
            .contentShape(Rectangle())
    }
}
