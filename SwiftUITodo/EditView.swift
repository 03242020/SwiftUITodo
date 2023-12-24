//
//  EditView.swift
//  SwiftUITodo
//
//  Created by ryo.inomata on 2023/11/19.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

//完了、未完了のラベルを活性にする
struct EditView: View {
    enum CategoryType: Int {
        case normal     = 0
        case just       = 1
        case remember   = 2
        case either     = 3
        case toBuy      = 4
    }
    @State private var email: String = ""
    @State private var year: String = ""
    @State private var useRedTextJust = false
    @State private var useRedTextRemember = false
    @State private var useRedTextEither = false
    @State private var useRedTextToBuy = false
    @State var todoInfo = TodoInfo()
    @State var selectDate = Date()
    @State var selectTime = Date()
    @State var todoIsDoneInit = "未完了"
    @State var todoIsCompletion = "完了済みにする"
    @Binding var isCheck: Bool
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
            TextField("資料作成", text: $todoInfo.todoTitle.bound)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack {
                DatePicker("", selection: $selectDate, displayedComponents: .date).labelsHidden()
                Spacer()
                DatePicker("", selection: $selectTime, displayedComponents: .hourAndMinute).labelsHidden()
            }
            Text(" CreatedAt: \(Text(todoInfo.todoCreated ?? ""))")
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(" UpdatedAt: \(Text(todoInfo.todoUpdated ?? ""))")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(
                    top: 0,
                    leading: 0,
                    bottom: 10,
                    trailing: 0
                ))
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
                            .onAppear() {
                                if todoInfo.todoViewType == 1 {
                                    self.useRedTextJust = true
                                }
                            }
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
                            .onAppear() {
                                if todoInfo.todoViewType == 2 {
                                    self.useRedTextRemember = true
                                }
                            }
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
                            .onAppear() {
                                if todoInfo.todoViewType == 3 {
                                    self.useRedTextEither = true
                                }
                            }
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
                            .onAppear() {
                                if todoInfo.todoViewType == 4 {
                                    self.useRedTextToBuy = true
                                }
                            }
                    })
                }
            }
            Text(" 詳細")
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("Detail", text: $todoInfo.todoDetail.bound)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text(" 状態")
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Text(todoIsDoneInit)
                    .onAppear {
                        switch todoInfo.todoIsDone {
                        case false:
                            todoIsDoneInit = "未完了"
                        case true:
                            todoIsDoneInit = "完了済み"
                        default:
                            break
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Button(action: {
                    // ボタンをタップした時のアクション
                    print("tap buton")
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
                                    isCheck.toggle()
                                    dismiss()
                                }
                            })
                    }
                }, label: {
                    // ボタン内部に表示するオブジェクト
                    Text(todoIsCompletion)
                        .onAppear {
                            switch todoInfo.todoIsDone {
                            case false:
                                todoIsCompletion = "完了済みにする"
                            case true:
                                todoIsCompletion = "未完了にする"
                            default:
                                break
                            }
                        }
                })
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            HStack {
                Button(action: {
                    if let user = Auth.auth().currentUser {
                        Firestore.firestore().collection("users/\(user.uid)/todos").document(todoInfo.id!).updateData(
                            [
                                "title": todoInfo.todoTitle ?? "",
                                "detail": todoInfo.todoDetail ?? "",
                                "updatedAt": FieldValue.serverTimestamp(),
                                "scheduleDate": todoInfo.todoScheduleDate ?? "",
                                "scheduleTime": todoInfo.todoScheduleTime ?? "",
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
                                    isCheck.toggle()
                                    dismiss()
                                }
                            })
                    }
                    // ボタンをタップした時のアクション
                    print("tap buton")
                }, label: {
                    // ボタン内部に表示するオブジェクト
                    Text("編集する")
                })
                .preference(key: BoolPreference.self, value: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Button(action: {
                    if let user = Auth.auth().currentUser {
                        Firestore.firestore().collection("users/\(user.uid)/todos").document(todoInfo.id!).delete() { error in
                            if let error = error {
                                print("TODO削除失敗: " + error.localizedDescription)
                                let dialog = UIAlertController(title: "TODO削除失敗", message: error.localizedDescription, preferredStyle: .alert)
                                dialog.addAction(UIAlertAction(title: "OK", style: .default))
                            } else {
                                print("TODO削除成功")
                                isCheck.toggle()
                                dismiss()
                            }
                        }
                    }
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
