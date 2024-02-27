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
                //不具合修正
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
                        switchColor()
                    }, label: {
                        Text("すぐやる")
                            .onAppear() {
                                if todoInfo.todoViewType == 1 {
                                    self.useRedTextJust = true
                                }
                            }
                    })
                    .buttonStyle(RoundedButtonStyle())
                    .foregroundColor(useRedTextJust ? .red : .blue)
                    Button(action: {
                        todoInfo.todoViewType = 2
                        switchColor()
                    }, label: {
                        Text("覚えとく")
                            .onAppear() {
                                if todoInfo.todoViewType == 2 {
                                    self.useRedTextRemember = true
                                }
                            }
                    })
                    .buttonStyle(RoundedButtonStyle())
                    .foregroundColor(useRedTextRemember ? .red : .blue)
                    Button(action: {
                        todoInfo.todoViewType = 3
                        switchColor()
                    }, label: {
                        Text("やるやら")
                            .onAppear() {
                                if todoInfo.todoViewType == 3 {
                                    self.useRedTextEither = true
                                }
                            }
                    })
                    .buttonStyle(RoundedButtonStyle())
                    .foregroundColor(useRedTextEither ? .red : .blue)
                    Button(action: {
                        todoInfo.todoViewType = 4
                        switchColor()
                    }, label: {
                        Text("買うもの")
                            .onAppear() {
                                if todoInfo.todoViewType == 4 {
                                    self.useRedTextToBuy = true
                                }
                            }
                    })
                    .buttonStyle(RoundedButtonStyle())
                    .foregroundColor(useRedTextToBuy ? .red : .blue)
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
                    callCompletionTodoDataForFirestore(todoInfo: todoInfo)
                }, label: {
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
                    callEditTodoDataForFirestore(todoInfo: todoInfo)
                }, label: {
                    Text("編集する")
                })
                .preference(key: BoolPreference.self, value: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Button(action: {
                    callDeleteTodoDataForFirestore(todoInfo: todoInfo)
                }, label: {
                    Text("削除する")
                })
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            Spacer()
        }
    }
    func switchColor() {
        resetColor()
        switch todoInfo.todoViewType {
        case 1:
            useRedTextJust = true
        case 2:
            useRedTextRemember = true
        case 3:
            useRedTextEither = true
        case 4:
            useRedTextToBuy = true
        default:
            break
        }
    }
    func resetColor() {
        useRedTextJust = false
        useRedTextEither = false
        useRedTextRemember = false
        useRedTextToBuy = false
    }
    func callEditTodoDataForFirestore(todoInfo: TodoInfo) {
        var tempSelectDateTime: SelectDateTime
        tempSelectDateTime = SelectDateTime(selectDate: dateFormat.string(from: selectDate), selectTime: dateFormat.string(from: selectTime))
        let editTodoTask = EditTodoTask()
        editTodoTask.editTodoDataForFirestore(todoInfo: todoInfo, selectDateTime: tempSelectDateTime , postTask: {
            isCheck.toggle()
            dismiss()
        })
    }
    func callDeleteTodoDataForFirestore(todoInfo: TodoInfo) {
        let deleteTodoTask = DeleteTodoTask()
        deleteTodoTask.deleteTodoDataForFirestore(todoInfo: todoInfo, postTask: {
            isCheck.toggle()
            dismiss()
        })
    }
    func callCompletionTodoDataForFirestore(todoInfo: TodoInfo) {
        let completionTodoTask = CompletionTodoTask()
        completionTodoTask.completionTodoDataForFirestore(todoInfo: todoInfo, postTask: {
            isCheck.toggle()
            dismiss()
        })
    }
    func dateFromString(string: String, format: String) -> Date {
            let formatter: DateFormatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.dateFormat = format
            return formatter.date(from: string)!
        }
}
