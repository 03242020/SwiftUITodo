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
    enum CategoryType: Int {
        case normal     = 0
        case just       = 1
        case remember   = 2
        case either     = 3
        case toBuy      = 4
    }
    @Environment(\.dismiss) private var dismiss
    @Environment(\.timeZone) private var timeZone
    @State var todoInfo = TodoInfo()
    @State var date = ""
    @State var time = ""
    @State var showPicker = false
    @State var selectDate = Date()
    @State var selectTime = Date()
    @State private var useRedTextJust = false
    @State private var useRedTextRemember = false
    @State private var useRedTextEither = false
    @State private var useRedTextToBuy = false
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
            TextField("資料作成", text: $todoInfo.todoTitle.bound)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack {
                DatePicker("", selection: $selectDate, displayedComponents: .date).labelsHidden()
                Spacer()
                DatePicker("", selection: $selectTime, displayedComponents: .hourAndMinute).labelsHidden()
            }
            Text("詳細")
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("detail", text: $todoInfo.todoDetail.bound)
                .frame(maxWidth: .infinity, alignment: .leading)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer()
            if self.showPicker {
                DatePicker(selection: $selectDate,displayedComponents: .date, label: {})
            }
            ZStack{
                HStack{
                    Button(action: {
                        todoInfo.todoViewType = 1
                        useRedTextJust = true
                        useRedTextRemember = false
                        useRedTextEither = false
                        useRedTextToBuy = false
                    }, label: {
                        Text("すぐやる")
                            .frame(width: 68, height: 34)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                            .foregroundColor(useRedTextJust ? .red : .blue)
                    })
                    Button(action: {
                        todoInfo.todoViewType = 2
                        useRedTextJust = false
                        useRedTextRemember = true
                        useRedTextEither = false
                        useRedTextToBuy = false
                    }, label: {
                        Text("覚えとく")
                            .frame(width: 68, height: 34)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                            .foregroundColor(useRedTextRemember ? .red : .blue)
                    })
                    Button(action: {
                        todoInfo.todoViewType = 3
                        useRedTextJust = false
                        useRedTextRemember = false
                        useRedTextEither = true
                        useRedTextToBuy = false
                    }, label: {
                        Text("やるやら")
                            .frame(width: 68, height: 34)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                            .foregroundColor(useRedTextEither ? .red : .blue)
                    })
                    Button(action: {
                        todoInfo.todoViewType = 4
                        useRedTextJust = false
                        useRedTextEither = false
                        useRedTextRemember = false
                        useRedTextToBuy = true
                    }, label: {
                        Text("買うもの")
                            .frame(width: 68, height: 34)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                            .foregroundColor(useRedTextToBuy ? .red : .blue)
                    })
                }
            }
            Button {
                    // ②ログイン済みか確認
                    if let user = Auth.auth().currentUser {
                        // ③FirestoreにTodoデータを作成する
                let createdTime = FieldValue.serverTimestamp()
                        Firestore.firestore().collection("users/\(user.uid)/todos").document().setData(
                            [
                                "title": todoInfo.todoTitle ?? "",
                                "detail": todoInfo.todoDetail ?? "",
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
                                } else {
                                    print("TODO作成成功")
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
