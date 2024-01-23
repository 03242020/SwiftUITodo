//
//  completionTodoTask.swift
//  SwiftUITodo
//
//  Created by ryo.inomata on 2024/01/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class CompletionTodoTask {
    func completionTodoDataForFirestore(todoInfo: TodoInfo, postTask: @escaping () -> Void) {
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users/\(user.uid)/todos").document(todoInfo.id!).updateData(
                [
                    "isDone": !todoInfo.todoIsDone!,
                    "viewType": todoInfo.todoViewType ?? 0,
                    "updatedAt": FieldValue.serverTimestamp()
                ]
                , completion: {error in
                    if let error = error {
                        print("TODO更新失敗: " + error.localizedDescription)
                        let dialog = UIAlertController(title: "TODO更新失敗", message: error.localizedDescription, preferredStyle: .alert)
                        dialog.addAction(UIAlertAction(title: "OK", style: .default))
                    } else {
                        print("TODO更新成功")
                        postTask()
                    }
                })
        }
    }
    // 参考にしたcompletion文
    //                    if let user = Auth.auth().currentUser {
    //                        Firestore.firestore().collection("users/\(user.uid)/todos").document(todoInfo.id!).updateData(
    //                            [
    //                                "isDone": !todoInfo.todoIsDone!,
    //                                "viewType": todoInfo.todoViewType ?? 0,
    //                                "updatedAt": FieldValue.serverTimestamp()
    //                            ]
    //                            , completion: {error in
    //                                if let error = error {
    //                                    print("TODO更新失敗: " + error.localizedDescription)
    //                                    let dialog = UIAlertController(title: "TODO更新失敗", message: error.localizedDescription, preferredStyle: .alert)
    //                                    dialog.addAction(UIAlertAction(title: "OK", style: .default))
    //                                } else {
    //                                    print("TODO更新成功")
    //                                    isCheck.toggle()
    //                                    dismiss()
    //                                }
    //                            })
    //                    }
}
