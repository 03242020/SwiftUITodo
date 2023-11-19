//
//  ResetPasswordView.swift
//  SwiftUITodo
//
//  Created by ryo.inomata on 2023/11/18.
//

import SwiftUI

struct ResetPasswordView: View {
    @State private var email: String = ""
    @ObservedObject var viewModel: AuthViewModel

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Reset Password") {
                viewModel.resetPassword(email: email)
            }
        }
    }
}
