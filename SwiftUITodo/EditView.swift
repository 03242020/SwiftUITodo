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
    @State var createdTime: String
    @State var updatedTime: String
    @State var id: String
    @State var todoInfo = TodoInfo()
    @State var selectDate = Date()
    @State var selectTime = Date()
    @Environment(\.timeZone) private var timeZone
    @Environment(\.dismiss) private var dismiss
    var dateFormat: DateFormatter {
        let dformat = DateFormatter()
        dformat.dateStyle = .medium
        dformat.timeStyle = .medium
        dformat.dateFormat = "yyyy/MM/dd"
        dformat.timeZone  = timeZone
        return dformat
    }
    var timeFormat: DateFormatter {
        let tformat = DateFormatter()
        tformat.dateStyle = .medium
        tformat.timeStyle = .medium
        tformat.dateFormat = "HH:mm"
        tformat.timeZone  = timeZone
        return tformat
    }
    var body: some View {
        VStack {
            //$email
            TextField("資料作成", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack {
                DatePicker("", selection: $selectDate, displayedComponents: .date).labelsHidden()
                Spacer()
                DatePicker("", selection: $selectTime, displayedComponents: .hourAndMinute).labelsHidden()
            }
            TextField("CreatedAt", text: $createdTime)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("UpdatedAt", text: $updatedTime)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("詳細")
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("Detail", text: $detail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("状態")
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Text("未完了")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Button(action: {
                    // ボタンをタップした時のアクション
                    print("tap buton")
                }, label: {
                    // ボタン内部に表示するオブジェクト
                    Text("完了済みにする")
                })
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            HStack {
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
                Spacer()
                Button(action: {
                    // ボタンをタップした時のアクション
                    print("tap buton")
                }, label: {
                    // ボタン内部に表示するオブジェクト
                    Text("削除する")
                })
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            Spacer()
        }
    }
}

//#Preview {
//    EditView(title: "", scheduleDate: "", scheduleTime: "", id: "")
//}
