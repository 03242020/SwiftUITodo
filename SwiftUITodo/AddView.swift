//
//  AddView.swift
//  SwiftUITodo
//
//  Created by ryo.inomata on 2023/11/20.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct AddView: View {
    @Environment(\.dismiss) private var dismiss
    @State var title: String
    @State var scheduleDate: String
    @State var scheduleTime: String
    @State private var detail: String = ""
    @State var date = ""
    @State var time = ""
    @State var editingText: String
    @State var showPicker = false
    @State var selectDate = Date()
    var body: some View {
        VStack {
            //$email
            TextField("資料作成", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("yearTextField", text: $scheduleDate)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("scheduleDate", text: $scheduleTime)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("詳細")
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("Detail", text: $detail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            DatePicker("", selection: $selectDate, displayedComponents: [.hourAndMinute, .date]).labelsHidden()
            
            DatePicker("", selection: $selectDate, displayedComponents: .hourAndMinute).labelsHidden()
            
            DatePicker("", selection: $selectDate, displayedComponents: .date).labelsHidden()
//        }.padding()
//            TextField("Your Text",
//                text: $editingText,
//                onEditingChanged: { editing in
//                    self.showPicker = editing
//                }
//            )
            .padding()
            if self.showPicker {
                DatePicker(selection: $selectDate,displayedComponents: .date, label: {})
            }
            Button {
                    // ②ログイン済みか確認
                    if let user = Auth.auth().currentUser {
                        // ③FirestoreにTodoデータを作成する
                let createdTime = FieldValue.serverTimestamp()
                        Firestore.firestore().collection("users/\(user.uid)/todos").document().setData(
                            [
                             "title": title,
                             "detail": detail,
                             "isDone": false,
                             "createdAt": createdTime,
                             "updatedAt": createdTime,
                             "scheduleDate": self.date,
                             "scheduleTime": self.time,
                             "viewType": 0
                            ],merge: true
                            ,completion: { error in
                                if let error = error {
                                    // ③が失敗した場合
                                    print("TODO作成失敗: " + error.localizedDescription)
                                    let dialog = UIAlertController(title: "TODO作成失敗", message: error.localizedDescription, preferredStyle: .alert)
                                    dialog.addAction(UIAlertAction(title: "OK", style: .default))
//                                    self.present(dialog, animated: true, completion: nil)
                                } else {
                                    print("TODO作成成功")
                                    // ④Todo一覧画面に戻る
//                                    let storyboard: UIStoryboard = self.storyboard!
//                                    let next = storyboard.instantiateViewController(withIdentifier: "TodoListViewController") as! TodoListViewController
//                                    next.viewType = self.todoListViewType
//                                    self.dismiss(animated: true, completion: nil)
                                }
                        })
                    }
            } label: {
                Text("追加する")
            }
            Button {
                dismiss()
            } label: {
                Text("閉じる")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        Spacer()
    }
}

#Preview {
    AddView(title: "", scheduleDate: "", scheduleTime: "", editingText: "")
}
