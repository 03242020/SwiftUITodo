//
//  getTodoTask.swift
//  SwiftUITodo
//
//  Created by ryo.inomata on 2024/01/15.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth


class GetTodoTask {
    typealias SamplePostTask = (HelloInfo?, Error?) -> Void
    var tempTodoArray: [TodoInfo] = [TodoInfo]()
    //errorキャッチしたら呼び出し元に送らないといけない
    //TODO
    func getTodoDataForFirestore(helloInfo: HelloInfo, postTask: @escaping ([TodoInfo]) -> Void) {
        tempTodoArray = [TodoInfo]()
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users/\(user.uid)/todos").whereField("isDone", isEqualTo: helloInfo.isDone ?? false).order(by: "createdAt").getDocuments(completion: { [self] (querySnapshot, error) in
                if let error = error {
                    print("TODO取得失敗: " + error.localizedDescription)
                } else {
                    if let querySnapshot = querySnapshot {
                        for doc in querySnapshot.documents {
                            //TodoInfoのみで、Codableを用いてUUIDをモデルに追加し
                            let data = doc.data()
                            //                            let todoId = doc.documentID
                            let id = doc.documentID
                            let todoTitle = data["title"] as? String
                            let todoDetail = data["detail"] as? String
                            let todoIsDone = data["isDone"] as? Bool
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let todoCreatedTimestamp = data["createdAt"] as? Timestamp
                            let todoCreatedDate = todoCreatedTimestamp?.dateValue()
                            let todoCreatedString = dateFormatter.string(from: todoCreatedDate ?? Date())
                            print("Date: ",Date())
                            let todoUpdatedTimestamp = data["updatedAt"] as? Timestamp
                            let todoUpdatedDate = todoUpdatedTimestamp?.dateValue()
                            let todoUpdatedString = dateFormatter.string(from: todoUpdatedDate ?? Date())
                            let todoScheduleDate = data["scheduleDate"] as? String ?? "yyyy/mm/dd"
                            let todoScheduleTime = data["scheduleTime"] as? String ?? "hh:mm"
                            let todoViewType = data["viewType"] as? Int ?? 0
                            var newTodo = TodoInfo()
                            newTodo = TodoInfo(id: id,todoTitle: todoTitle,todoDetail: todoDetail,todoIsDone: todoIsDone,todoCreated: todoCreatedString,todoUpdated: todoUpdatedString, todoScheduleDate: todoScheduleDate,todoScheduleTime: todoScheduleTime,todoViewType: todoViewType)
                            tempTodoArray.append(newTodo)
                            // オプショナル型にして、String以外の場合は、固定値を入れる記述。
                            // 強制アンラップは極力やめる
                            // 必須の要素はas!強制をする。あるかないか、scheduleDateArray等
                            // はオプショナル型の使用を推奨
                            // クラッシュの原因は大きい割合で、強制アンラップがありうるので気を付ける。
                            // Swift入門53Pあたりのオプショナルを読み直す
                            //scheduleDateArray?.append(data["scheduleDate"] as? String ?? "yyyy/mm/dd hh:mm")
                        }
                        print(tempTodoArray)
                        postTask(tempTodoArray)
                    }
                }
            })
        }
    }
    func getTodoCategoryDataForFirestore(helloInfo: HelloInfo, postTask: @escaping ([TodoInfo]) -> Void) {
        tempTodoArray = [TodoInfo]()
        
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users/\(user.uid)/todos").whereField("isDone", isEqualTo: helloInfo.isDone ?? false).order(by: "createdAt").whereField("viewType", isEqualTo:  helloInfo.viewType ?? 0).getDocuments(completion: { [self] (querySnapshot, error) in
                if let error = error {
                    print("TODO取得失敗: " + error.localizedDescription)
                } else {
                    if let querySnapshot = querySnapshot {
                        for doc in querySnapshot.documents {
                            //TodoInfoのみで、Codableを用いてUUIDをモデルに追加し
                            let data = doc.data()
                            //                            let todoId = doc.documentID
                            let id = doc.documentID
                            let todoTitle = data["title"] as? String
                            let todoDetail = data["detail"] as? String
                            let todoIsDone = data["isDone"] as? Bool
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let todoCreatedTimestamp = data["createdAt"] as? Timestamp
                            let todoCreatedDate = todoCreatedTimestamp?.dateValue()
                            let todoCreatedString = dateFormatter.string(from: todoCreatedDate ?? Date())
                            print("Date: ",Date())
                            let todoUpdatedTimestamp = data["updatedAt"] as? Timestamp
                            let todoUpdatedDate = todoUpdatedTimestamp?.dateValue()
                            let todoUpdatedString = dateFormatter.string(from: todoUpdatedDate ?? Date())
                            let todoScheduleDate = data["scheduleDate"] as? String ?? "yyyy/mm/dd"
                            let todoScheduleTime = data["scheduleTime"] as? String ?? "hh:mm"
                            let todoViewType = data["viewType"] as? Int ?? 0
                            var newTodo = TodoInfo()
                            newTodo = TodoInfo(id: id,todoTitle: todoTitle,todoDetail: todoDetail,todoIsDone: todoIsDone,todoCreated: todoCreatedString,todoUpdated: todoUpdatedString, todoScheduleDate: todoScheduleDate,todoScheduleTime: todoScheduleTime,todoViewType: todoViewType)
                            tempTodoArray.append(newTodo)
                            // オプショナル型にして、String以外の場合は、固定値を入れる記述。
                            // 強制アンラップは極力やめる
                            // 必須の要素はas!強制をする。あるかないか、scheduleDateArray等
                            // はオプショナル型の使用を推奨
                            // クラッシュの原因は大きい割合で、強制アンラップがありうるので気を付ける。
                            // Swift入門53Pあたりのオプショナルを読み直す
                            //scheduleDateArray?.append(data["scheduleDate"] as? String ?? "yyyy/mm/dd hh:mm")
                        }
                        print(tempTodoArray)
                        postTask(tempTodoArray)
                    }
                }
            })
        }
    }
}
