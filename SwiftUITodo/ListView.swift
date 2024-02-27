//
//  HelloPage.swift
//  SwiftUITodo
//
//  Created by ryo.inomata on 2023/11/18.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
//うううううううううううううううううううううううううううううう＾＾＾＾＾
//カメラ機能について確認する。アプリ内で撮ってからアプリ内で表示する。など
struct HelloInfo {
    var isDone: Bool?
    var viewType: Int?
}

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
    
    @State var selectedCompletion: SegmentType = .zero
//    @State var getTodoArray: [TodoInfo] = [TodoInfo]()
    @State var helloInfo: HelloInfo
    @State var getTodoArrayEdit = TodoInfo()
    @State var addActive: Bool = false
    @State var isPresented: Bool = false
    @State var path = NavigationPath()
    @State private var showingEditView = false
    //Holderを使いたかったがState(値の監視)が機能してくれない
    //foregroundColor(useRedTextAll ? .red : .blue)
    @State private var useRedTextAll = false
    @State private var useRedTextJust = false
    @State private var useRedTextRemember = false
    @State private var useRedTextEither = false
    @State private var useRedTextToBuy = false
    @State var state: Bool = false
    @State var isCheck: Bool = false
    @State var addIsCheck: Bool = false
    
    @ObservedObject var listViewModel = ListViewModel()
    @ObservedObject var itemListViewModel: ItemListViewModel
    
    var body: some View {
        VStack{
                Button(action: {
                    viewModel.signOut()
                }, label: {
                    Text("logout")
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 0))
            Text("")
                .onAppear {
                    useRedTextAll = true
                    itemListViewModel.switchGetTodoDataForFirestore(helloInfo: helloInfo)
//                    callGetTodoDataForFirestore(helloInfo: helloInfo)
                }
            NavigationStack {
                List(self.itemListViewModel.items){Array in
                    Button(Array.todoTitle ?? "取得不可"){
                        isPresented.toggle()
                        getTodoArrayEdit = Array
                    }
                }
                .refreshable {
                    itemListViewModel.switchGetTodoDataForFirestore(helloInfo: helloInfo)
//                    switchGetTodoDataForFirestore()
                           }
                .navigationDestination(isPresented: $isPresented) {
                    EditView(todoInfo: getTodoArrayEdit, isCheck: $isCheck)
                        .onPreferenceChange(BoolPreference.self) { value in
                            self.state = value
                        }
                    
                    //TODO猪股編集押下でこちらが動く様に調整
                    //ボタン領域内に合わせる
                    //カテゴリと追加ボタン
                    //もっと急がないといけない
                    //TODO猪股追加処理で実装すべき。戻るで読み込み発生しない様にする。
                    //期限本日
                        .onDisappear() {
                            if isCheck == true {
                                //ここの利用にViewModelから出来たらいいな
                                itemListViewModel.switchGetTodoDataForFirestore(helloInfo: helloInfo)
//                                switchGetTodoDataForFirestore()
                                isCheck.toggle()
                            }
                        }
                }
                //navigationStackの方を優先的に使おう
                //destinationに書き換える
                //ALLが初期表示なので赤色で表示すべき
                //空の場合はタイトル
                //edit画面のテキストフィールドをはじの方を空白を開ける
                ZStack{
                    HStack{
                        Button(action: {
                            helloInfo.viewType = 0
                            resetColor()
                            listViewModel.switchRedText(viewType: helloInfo.viewType ?? 0)
//                            switchColor(redText: listViewModel.redText)
                            useRedTextAll = listViewModel.model.useRedTextAll
                            itemListViewModel.callGetTodoDataForFirestore(helloInfo: helloInfo)
//                            callGetTodoDataForFirestore(helloInfo: helloInfo)
                        }, label: {
                            Text("ALL")
                        })
                        .buttonStyle(RoundedButtonStyle())
                        //helloのstateにmodelの値を都度代入するようにすればいける気がする
                        .foregroundColor(useRedTextAll ? .red : .blue)
                        .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
                        
                        Button(action: {
                            helloInfo.viewType = 1
                            resetColor()

                             listViewModel.switchRedText(viewType: helloInfo.viewType ?? 0)
                            useRedTextJust = listViewModel.model.useRedTextJust
                            itemListViewModel.callGetTodoCategoryDataForFirestore(helloInfo: helloInfo)
//                            callGetTodoCategoryDataForFirestore(helloInfo: helloInfo)
                        }, label: {
                            Text("すぐやる")
                                .contentShape(Rectangle())
                        })
                        .buttonStyle(RoundedButtonStyle())
                        .foregroundColor(useRedTextJust ? .red : .blue)
                        .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
                        Button(action: {
                            helloInfo.viewType = 2
                            resetColor()
                            listViewModel.switchRedText(viewType: helloInfo.viewType ?? 0)
                            useRedTextRemember = listViewModel.model.useRedTextRemember
                            itemListViewModel.callGetTodoCategoryDataForFirestore(helloInfo: helloInfo)
//                            callGetTodoCategoryDataForFirestore(helloInfo: helloInfo)
                        }, label: {
                            Text("覚えとく")
                        })
                        .buttonStyle(RoundedButtonStyle())
                        .foregroundColor(useRedTextRemember ? .red : .blue)
                        .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
                        Button(action: {
                            helloInfo.viewType = 3
                            resetColor()
                            listViewModel.switchRedText(viewType: helloInfo.viewType ?? 0)
                            useRedTextEither = listViewModel.model.useRedTextEither
                            itemListViewModel.callGetTodoCategoryDataForFirestore(helloInfo: helloInfo)
//                            callGetTodoCategoryDataForFirestore(helloInfo: helloInfo)
                        }, label: {
                            Text("やるやら")
                        })
                        .buttonStyle(RoundedButtonStyle())
                        .foregroundColor(useRedTextEither ? .red : .blue)
                        .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
                        Button(action: {
                            helloInfo.viewType = 4
                            resetColor()
                            listViewModel.switchRedText(viewType: helloInfo.viewType ?? 0)
                            useRedTextToBuy = listViewModel.model.useRedTextToBuy
                            itemListViewModel.callGetTodoCategoryDataForFirestore(helloInfo: helloInfo)
//                            callGetTodoCategoryDataForFirestore(helloInfo: helloInfo)
                        }, label: {
                            Text("買うもの")
                        })
                        .buttonStyle(RoundedButtonStyle())
                        .foregroundColor(useRedTextToBuy ? .red : .blue)
                        .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
                    }
                }
                HStack {
                    ZStack {
                        NavigationStack {
                            Button(action: {
                                addActive.toggle()
                            }, label: {
                                Image(systemName: "pencil")
                                    .resizable()
                                    .buttonStyle(.plain)
                                    .frame(width: 24.0, height: 24.0)
                            })
                            //今回外周部分にタップ領域伸びてた原因はpadding(.all)
                            //padding以外に大きさの指定をする方法を考える
                            //カテゴリボタンのタップ領域を画像内に狭める
                            .padding(.all, 12.0)
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(24.0)
                            .shadow(color: .black.opacity(0.3),
                                    radius: 5.0,
                                    x: 1.0, y: 1.0)
                            .clipped()
                            .padding(EdgeInsets(top: 0, leading: 300, bottom: -23.0, trailing: 16.0))
                            .navigationDestination(isPresented: $addActive) {
                                AddView(addIsCheck: $addIsCheck, itemListViewModel: ItemListViewModel())
                                    .onPreferenceChange(BoolPreference.self) { value in
                                        self.state = value
                                    }
                                    .onDisappear() {
                                        if addIsCheck == true {
//                                            switchGetTodoDataForFirestore()
                                            itemListViewModel.switchGetTodoDataForFirestore(helloInfo: helloInfo)
                                            addIsCheck.toggle()
                                        }
                                    }
                            }
                        }
                    }
                }
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
                            helloInfo.isDone = false
                            itemListViewModel.switchGetTodoDataForFirestore(helloInfo: helloInfo)
//                            switchGetTodoDataForFirestore()
                        case .one:
                            helloInfo.isDone = true
                            itemListViewModel.switchGetTodoDataForFirestore(helloInfo: helloInfo)
//                            switchGetTodoDataForFirestore()
                        }
                    }
                    .onAppear {
                        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.red], for: .selected)
                    }
            }
        }
    }

//    func callGetTodoDataForFirestore(helloInfo: HelloInfo) {
//        let getTodoTask = GetTodoTask()
//        getTodoTask.getTodoDataForFirestore(helloInfo: helloInfo, postTask: {tempTodoArray in
//            getTodoArray = tempTodoArray
//        })
//    }
//    func callGetTodoCategoryDataForFirestore(helloInfo: HelloInfo) {
//        let getTodoTask = GetTodoTask()
//        getTodoTask.getTodoCategoryDataForFirestore(helloInfo: helloInfo, postTask:
//                                                        {tempTodoArray in
//            getTodoArray = tempTodoArray
//        })
//    }
    func resetColor() {
        useRedTextAll = false
        useRedTextJust = false
        useRedTextEither = false
        useRedTextRemember = false
        useRedTextToBuy = false
    }
//    func switchGetTodoDataForFirestore() {
//        switch helloInfo.viewType {
//        case 0:
//            callGetTodoDataForFirestore(helloInfo: helloInfo)
//        default:
//            callGetTodoCategoryDataForFirestore(helloInfo: helloInfo)
//        }
//    }
}
