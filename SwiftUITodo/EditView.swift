//
//  EditView.swift
//  SwiftUITodo
//
//  Created by ryo.inomata on 2023/11/19.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


struct EditView: View {
    @State private var email: String = ""
    @State private var year: String = ""
    @State private var detail: String = ""
    @State var title: String
    @State var scheduleDate: String
    @State var scheduleTime: String
    @State var id: String
    @State var todoInfo = TodoInfo()
    @Environment(\.dismiss) private var dismiss
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
            Text("状態")
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("未完了")
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(action: {
                // ボタンをタップした時のアクション
                print("tap buton")
            }, label: {
                // ボタン内部に表示するオブジェクト
                Text("完了済みにする")
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            Button(action: {
//                if let title = $title,
//                   let detail = $detail {
                    if let user = Auth.auth().currentUser {
                        Firestore.firestore().collection("users/\(user.uid)/todos").document(id).updateData(
                        [
                            "title": title,
                            "detail": detail,
                            "updatedAt": FieldValue.serverTimestamp(),
                            "scheduleDate": scheduleDate,
                            "scheduleTime": scheduleTime,
                            "viewType": todoInfo.todoViewType ?? 0,
                        ]
                        , completion: { error in
                            if let error = error {
                                print("TODO更新失敗: " + error.localizedDescription)
                                let dialog = UIAlertController(title: "TODO更新失敗", message: error.localizedDescription, preferredStyle: .alert)
                                dialog.addAction(UIAlertAction(title: "OK", style: .default))
//                                self.present(dialog, animated: true, completion: nil)
                            } else {
                                print("TODO更新成功")
                                dismiss()
                            }
                        })
                    }
//                }
                // ボタンをタップした時のアクション
                print("tap buton")
                
                
            }, label: {
                // ボタン内部に表示するオブジェクト
                Text("編集する")
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            Button(action: {
                // ボタンをタップした時のアクション
                print("tap buton")
            }, label: {
                // ボタン内部に表示するオブジェクト
                Text("削除する")
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        TextField("Detail", text: $detail)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
        Text("状態")
    }
}

#Preview {
    EditView(title: "", scheduleDate: "", scheduleTime: "", id: "")
}
