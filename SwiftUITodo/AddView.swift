//
//  AddView.swift
//  SwiftUITodo
//
//  Created by ryo.inomata on 2023/11/20.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SelectDateTime {
    var selectDate: String?
    var selectTime: String?
}
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
    @Binding var addIsCheck: Bool
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
    @ObservedObject var itemListViewModel: ItemListViewModel
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
                        switchColor()
                    }, label: {
                        Text("すぐやる")
                    })
                    .buttonStyle(RoundedButtonStyle())
                    .foregroundColor(useRedTextJust ? .red : .blue)
                    Button(action: {
                        todoInfo.todoViewType = 2
                        switchColor()
                    }, label: {
                        Text("覚えとく")
                    })
                    .buttonStyle(RoundedButtonStyle())
                    .foregroundColor(useRedTextRemember ? .red : .blue)
                    Button(action: {
                        todoInfo.todoViewType = 3
                        switchColor()
                    }, label: {
                        Text("やるやら")
                    })
                    .buttonStyle(RoundedButtonStyle())
                    .foregroundColor(useRedTextEither ? .red : .blue)
                    Button(action: {
                        todoInfo.todoViewType = 4
                        switchColor()
                    }, label: {
                        Text("買うもの")
                    })
                    .buttonStyle(RoundedButtonStyle())
                    .foregroundColor(useRedTextToBuy ? .red : .blue)
                }
            }
            Button {
                itemListViewModel.callAddTodoDataForFirestore(todoInfo: todoInfo, tempSelectDateTime: SelectDateTime(selectDate: dateFormat.string(from: selectDate), selectTime: dateFormat.string(from: selectTime)))
                //クロージャで後から処理に後程修正
                addIsCheck.toggle()
                dismiss()
//                callAddTodoDataForFirestore(todoInfo: todoInfo)
            } label: {
                Text("追加する")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        Spacer()
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
    func callAddTodoDataForFirestore(todoInfo: TodoInfo) {
        var tempSelectDateTime: SelectDateTime
        tempSelectDateTime = SelectDateTime(selectDate: dateFormat.string(from: selectDate), selectTime: dateFormat.string(from: selectTime))
        let addTodoTask = AddTodoTask()
        addTodoTask.addTodoDataForFirestore(todoInfo: todoInfo, selectDateTime: tempSelectDateTime , postTask: {
            addIsCheck.toggle()
            dismiss()
        })
    }
}

