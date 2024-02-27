//
//  ListModel.swift
//  SwiftUITodo
//
//  Created by ryo.inomata on 2024/01/30.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

//@MainActor
struct ListModel {
    enum RedText: String {
        case useRedTextAll
        case useRedTextJust
        case useRedTextRemember
        case useRedTextEither
        case useRedTextToBuy
    }
    var redText: RedText = .useRedTextAll
    var useRedTextAll = false
    var useRedTextJust = false
    var useRedTextRemember = false
    var useRedTextEither = false
    var useRedTextToBuy = false
    
    mutating func switchRedText(viewType: Int) {
        useRedTextAll = false
        useRedTextJust = false
        useRedTextRemember = false
        useRedTextEither = false
        useRedTextToBuy = false
        switch viewType {
        case 0:
            useRedTextAll = true
        case 1:
            useRedTextJust = true
        case 2:
            useRedTextRemember = true
        case 3:
            useRedTextEither = true
        case 4:
            useRedTextToBuy = true
        default:
            break
        }
    }
    enum CategoryType: Int {
        case normal     = 0
        case just       = 1
        case remember   = 2
        case either     = 3
        case toBuy      = 4
    }
    
    enum SegmentType: CaseIterable {
        case zero
        case one
    }
}
