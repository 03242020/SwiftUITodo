//  ListViewModel.swift
//  SwiftUITodo
//
//  Created by ryo.inomata on 2024/01/30.
//

import Foundation
import SwiftUI

class ListViewModel: ObservableObject {
   @Published var model:ListModel = ListModel()
    var redText: String {
        return model.redText.rawValue
    }
    func switchRedText(viewType: Int) {
        model.switchRedText(viewType: viewType)
    }
}
