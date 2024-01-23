//
//  ViewModel.swift
//  SwiftUITodo
//
//  Created by ryo.inomata on 2023/11/28.
//

import Foundation
import SwiftUI

final class ViewModel: ObservableObject {
    @Published var name = ""
}

struct BoolPreference: PreferenceKey {
    typealias Value = Bool

    static var defaultValue: Value = false

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue() || value
    }
}
//ViewModelを活用して実装する
//TODOViewModelを調査する。
//MVVMで出来てるSwiftUI
//クリーンアーキテクチャについても調査する
//1日1時間割いてAppleTutorialを完了する
//チュートリアル完了後にTODOアプリを改めてみる
//全部TODOを行うのは少し勿体無い
//自身で足りないと認識した部分は進めてもよく、どこまで時間を割いたのかといった、内容的な共有をする。
//方向性が違えばご指摘いただける
