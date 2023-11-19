//
//  SwiftUITodoApp.swift
//  SwiftUITodo
//
//  Created by ryo.inomata on 2023/11/18.
//

import SwiftUI

@main
struct SwiftUITodoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var viewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            // ログイン状態によって画面遷移するページを変更する
            if viewModel.isAuthenticated {
                HelloPage(viewModel: viewModel)
            } else {
                SignInView(viewModel: viewModel)
            }
        }
    }
}
    
//import SwiftUI
//
//@main
//struct SwiftUITodoApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}
