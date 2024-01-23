//
//  AddTodoTask.swift
//  SwiftUITodo
//
//  Created by ryo.inomata on 2024/01/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AddTodoTask {
    var tempTodoInfo = TodoInfo()
    func addTodoDataForFirestore(todoInfo: TodoInfo, selectDateTime: SelectDateTime, postTask: @escaping () -> Void) {
        tempTodoInfo = todoInfo
        if let user = Auth.auth().currentUser {
            // ③FirestoreにTodoデータを作成する
            let createdTime = FieldValue.serverTimestamp()
            Firestore.firestore().collection("users/\(user.uid)/todos").document().setData(
                [
                    "title": tempTodoInfo.todoTitle ?? "",
                    "detail": tempTodoInfo.todoDetail ?? "",
                    "isDone": false,
                    "createdAt": createdTime,
                    "updatedAt": createdTime,
                    "scheduleDate": selectDateTime.selectDate ?? "失敗",
                    "scheduleTime": selectDateTime.selectTime ?? "失敗",
                    "viewType": tempTodoInfo.todoViewType ?? 0
                ],merge: true
                ,completion: { error in
                    if let error = error {
                        // ③が失敗した場合
                        print("TODO作成失敗: " + error.localizedDescription)
                        let dialog = UIAlertController(title: "TODO作成失敗", message: error.localizedDescription, preferredStyle: .alert)
                        dialog.addAction(UIAlertAction(title: "OK", style: .default))
                    } else {
                        print("TODO作成成功")
                        postTask()
                    }
                })
        }
    }
    // 元にしたAddViewにあった記述
    //                    // ②ログイン済みか確認
    //                    if let user = Auth.auth().currentUser {
    //                        // ③FirestoreにTodoデータを作成する
    //                let createdTime = FieldValue.serverTimestamp()
    //                        Firestore.firestore().collection("users/\(user.uid)/todos").document().setData(
    //                            [
    //                                "title": todoInfo.todoTitle ?? "",
    //                                "detail": todoInfo.todoDetail ?? "",
    //                             "isDone": false,
    //                             "createdAt": createdTime,
    //                             "updatedAt": createdTime,
    //                             "scheduleDate": dateFormat.string(from: selectDate),
    //                             "scheduleTime": timeFormat.string(from: selectTime),
    //                                "viewType": todoInfo.todoViewType ?? 0
    //                            ],merge: true
    //                            ,completion: { error in
    //                                if let error = error {
    //                                    // ③が失敗した場合
    //                                    print("TODO作成失敗: " + error.localizedDescription)
    //                                    let dialog = UIAlertController(title: "TODO作成失敗", message: error.localizedDescription, preferredStyle: .alert)
    //                                    dialog.addAction(UIAlertAction(title: "OK", style: .default))
    //                                } else {
    //                                    print("TODO作成成功")
    //                                    addIsCheck.toggle()
    //                                    dismiss()
    //                                }
    //                        })
    //                    }
}
