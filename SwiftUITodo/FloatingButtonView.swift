//
//  FloadtingButtonView.swift
//  SwiftUITodo
//
//  Created by ryo.inomata on 2023/11/27.
//

import SwiftUI

struct FloatingButtonView: View {
    var body: some View {
        Button {
         } label: {
             Image(systemName: "rectangle.stack.badge.plus")
                 .resizable()
                 .scaledToFit()
                 .frame(width: 24.0, height: 24.0)
                 .foregroundColor(.white)
                 .padding(.all, 12.0)
                 .background(Color.red)
                 .cornerRadius(24.0)
                 .shadow(color: .black.opacity(0.3),
                         radius: 5.0,
                         x: 1.0, y: 1.0)
         }
    }
}

#Preview {
    FloatingButtonView()
}
