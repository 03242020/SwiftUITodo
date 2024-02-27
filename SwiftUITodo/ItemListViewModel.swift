//
//  ItemListViewModel.swift
//  SwiftUITodo
//
//  Created by ryo.inomata on 2024/02/20.
//

import Foundation
import SwiftUI

class ItemListViewModel: ObservableObject {
    @Published var items: [TodoInfo] = [TodoInfo]()
    
    func callGetTodoDataForFirestore(helloInfo: HelloInfo) {
        let getTodoTask = GetTodoTask()
        getTodoTask.getTodoDataForFirestore(helloInfo: helloInfo, postTask: {tempTodoArray in
            self.items = tempTodoArray
        })
    }
    func callGetTodoCategoryDataForFirestore(helloInfo: HelloInfo) {
        let getTodoTask = GetTodoTask()
        getTodoTask.getTodoCategoryDataForFirestore(helloInfo: helloInfo, postTask:
                                                        {tempTodoArray in
            self.items = tempTodoArray
        })
    }
    func switchGetTodoDataForFirestore(helloInfo: HelloInfo) {
        switch helloInfo.viewType {
        case 0:
            callGetTodoDataForFirestore(helloInfo: helloInfo)
        default:
            callGetTodoCategoryDataForFirestore(helloInfo: helloInfo)
        }
    }
    func callAddTodoDataForFirestore(todoInfo: TodoInfo, tempSelectDateTime: SelectDateTime) {
//        var tempSelectDateTime: SelectDateTime
//        tempSelectDateTime = SelectDateTime(selectDate: dateFormat.string(from: selectDate), selectTime: dateFormat.string(from: selectTime))
        let addTodoTask = AddTodoTask()
        addTodoTask.addTodoDataForFirestore(todoInfo: todoInfo, selectDateTime: tempSelectDateTime , postTask: {
//            addIsCheck.toggle()
//            dismiss()
        })
    }
}
