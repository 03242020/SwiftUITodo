//
//  DeleteTodoTask.swift
//  SwiftUITodo
//
//  Created by ryo.inomata on 2024/01/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DeleteTodoTask {
    func deleteTodoDataForFirestore(todoInfo: TodoInfo, postTask: @escaping () -> Void) {
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users/\(user.uid)/todos").document(todoInfo.id!).delete() { error in
                if let error = error {
                    print("TODO削除失敗: " + error.localizedDescription)
                    let dialog = UIAlertController(title: "TODO削除失敗", message: error.localizedDescription, preferredStyle: .alert)
                    dialog.addAction(UIAlertAction(title: "OK", style: .default))
                } else {
                    print("TODO削除成功")
                    postTask()
                }
            }
        }
    }
    // 参考にしたdelete文
    //                    if let user = Auth.auth().currentUser {
    //                        Firestore.firestore().collection("users/\(user.uid)/todos").document(todoInfo.id!).delete() { error in
    //                            if let error = error {
    //                                print("TODO削除失敗: " + error.localizedDescription)
    //                                let dialog = UIAlertController(title: "TODO削除失敗", message: error.localizedDescription, preferredStyle: .alert)
    //                                dialog.addAction(UIAlertAction(title: "OK", style: .default))
    //                            } else {
    //                                print("TODO削除成功")
    //                                isCheck.toggle()
    //                                dismiss()
    //                            }
    //                        }
    //                    }
}
