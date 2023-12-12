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
    enum SegmentType: CaseIterable {
        case zero
        case one
    }
    var viewModel: AuthViewModel
    var viewType = CategoryType.normal.rawValue
    
    @State var selectedCompletion: SegmentType = .zero
    @State var isDone: Bool? = false
    @State var showSecondView = false
    @State var showHogeText = false
    @State var getTodoArray: [TodoInfo] = [TodoInfo]()
    @State private var showSheet: Bool = false
    @State var addActive: Bool = false
    @State var path = NavigationPath()
    
    func getTodoDataForFirestore() {
        getTodoArray = [TodoInfo]()
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users/\(user.uid)/todos").whereField("isDone", isEqualTo: isDone ?? false).order(by: "createdAt").getDocuments(completion: { (querySnapshot, error) in
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
    
    var body: some View {
        VStack{
            Text("")
                .onAppear {
                    getTodoDataForFirestore()
                }
            NavigationStack {
                List(getTodoArray) { getTodoArray in
                    NavigationLink(destination: EditView(
                        todoInfo: getTodoArray)
                        .onDisappear() {
                            getTodoDataForFirestore()
                        }){
                            Text(getTodoArray.todoTitle!)
                        }
                        .navigationBarTitle("NavBar")
                }
                ZStack {
                    Picker("未完了、完了済み", selection: $selectedCompletion) {
                        ForEach(SegmentType.allCases, id: \.self) {
                            type in
                            switch type {
                            case .zero:
                                Text("未完了")
                            case .one:
                                Text("完了済み")
                            }
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding()
                        .onChange(of: selectedCompletion) {
                            switch selectedCompletion {
                            case .zero:
                                isDone = false
                                getTodoDataForFirestore()
                            case .one:
                                isDone = true
                                getTodoDataForFirestore()
                            }
                        }
                    NavigationStack {
                        Button(action: {
                            addActive.toggle()
                        }, label: {
                            Image(systemName: "pencil")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24.0, height: 24.0)
                                .foregroundColor(.white)
                                .padding(.all, 12.0)
                                .background(Color.red)
                                .cornerRadius(24.0)
                                .shadow(color: .black.opacity(0.3),
                                        radius: 5.0,
                                        x: 1.0, y: 1.0)
                                .padding(EdgeInsets(top: -110, leading: 300, bottom: 16.0, trailing: 16.0))
                        })
                        .navigationDestination(isPresented: $addActive) {
                            AddView().onDisappear() {
                                getTodoDataForFirestore()
                            }
                        }
                    }
                }
                
            }

        }
    }
}

