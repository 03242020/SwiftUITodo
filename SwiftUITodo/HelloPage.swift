//
//  HelloPage.swift
//  SwiftUITodo
//
//  Created by ryo.inomata on 2023/11/18.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

    // ログイン後の画面
struct HelloPage: View {
    enum CategoryType: Int {
        case normal     = 0
        case just       = 1
        case remember   = 2
        case either     = 3
        case toBuy      = 4
    }
    var viewType = CategoryType.normal.rawValue
    var isDone: Bool? = false
    func getTodoDataForFirestore() {
        getTodoArray = [TodoInfo]()
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users/\(user.uid)/todos").whereField("isDone", isEqualTo: isDone ?? false).order(by: "createdAt").getDocuments(completion: { (querySnapshot, error) in
                if let error = error {
                    print("TODO取得失敗: " + error.localizedDescription)
                } else {
                    if let querySnapshot = querySnapshot {
                        for doc in querySnapshot.documents {
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
                            self.getTodoArray.append(newTodo)
                            // オプショナル型にして、String以外の場合は、固定値を入れる記述。
                            // 強制アンラップは極力やめる
                            // 必須の要素はas!強制をする。あるかないか、scheduleDateArray等
                            // はオプショナル型の使用を推奨
                            // クラッシュの原因は大きい割合で、強制アンラップがありうるので気を付ける。
                            // Swift入門53Pあたりのオプショナルを読み直す
                            //scheduleDateArray?.append(data["scheduleDate"] as? String ?? "yyyy/mm/dd hh:mm")
                        }
                        print(getTodoArray)
                        //                        self.tableView.reloadData()
                    }
                }
            })
        }
    }
    var viewModel: AuthViewModel
    let data: [String] = ["huga", "hoge", "hugahuga"]
    @State var showHogeText = false
    @State var getTodoArray: [TodoInfo] = [TodoInfo]()
    @State private var showSheet: Bool = false
    @State private var addActive: Bool = false
    var body: some View {
        VStack{
            Text("Table編").font(.title)
            NavigationView {
                List(getTodoArray) { getTodoArray in
                    NavigationLink(destination: EditView(title: getTodoArray.todoTitle ?? "値渡し失敗", scheduleDate: getTodoArray.todoScheduleDate ?? "値渡し失敗", scheduleTime: getTodoArray.todoScheduleTime ?? "値渡し失敗", id: getTodoArray.id!, todoInfo: getTodoArray)){
                        Text(getTodoArray.todoTitle!)
                    }
                }
            }
            Spacer(minLength: 0)
            //            }
            VStack{
                Button(action: {
                    getTodoDataForFirestore()
                }) {
                    Text("list表示")
                }
                Button {
                    addActive.toggle()
                } label: {
                    HStack{
                        Image(systemName: "arrowshape.right.fill")
                        Text("NextPage")
                    }
                }
                .fullScreenCover(isPresented: $addActive, content: {
                    AddView(title: "", scheduleDate: "", scheduleTime: "", editingText: "")
                        })
            }
        }
    }
}
