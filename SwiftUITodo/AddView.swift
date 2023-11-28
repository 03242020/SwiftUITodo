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
    @Environment(\.timeZone) private var timeZone
    @State var title: String
    @State var scheduleDate: String
    @State var scheduleTime: String
    @State private var detail: String = ""
    @State var date = ""
    @State var time = ""
    @State var editingText: String
    @State var showPicker = false
    @State var selectDate = Date()
    @State var selectTime = Date()
    @Binding var isPresent: Bool
        // FirstViewから呼び出す際にFirstViewで初期化したViewModel変数を指定
    @ObservedObject var userName: ViewModel
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
            Text("詳細")
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("detail", text: $detail)
                .frame(maxWidth: .infinity, alignment: .leading)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer()

//            Text("Original: \(selectDate.description)")
//            Text("DateFormat: \(selectDate, formatter: dateFormat)")
//            Text("TimeFormat: \(selectTime, formatter: timeFormat)")
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
                             "scheduleDate": dateFormat.string(from: selectDate),
                             "scheduleTime": timeFormat.string(from: selectTime),
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
                                    self.isPresent = false
                                    dismiss()
                                }
                        })
                    }
            } label: {
                Text("追加する")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        Spacer()
    }
}

//#Preview {
//    AddView(title: "", scheduleDate: "", scheduleTime: "", editingText: "", isPresent: false, userName: "")
//}
