//
//  ContentView.swift
//  TodoAppSwifftUI
//
//  Created by Medeu Pazylov on 19.07.2023.
//

import SwiftUI

struct ContentView: View {
    var todoItems: [TodoItem]
    
    var body: some View {
        ZStack {
            Color(uiColor: Constants.backPrimary!)
            NavigationView {
                TodoList(todoItems: todoItems)
            }
        }
        
        
    }
}


struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView(todoItems: items)
    }
    
}


struct TodoList: View {
    var todoItems: [TodoItem]
    @State private var isShowingModal = false
    
    var body: some View {
        List {
            Section {
                ForEach(todoItems, id: \.id)  { todoItem in
                    TodoItemCellSwiftUI(model: todoItem)
                        .onTapGesture {
                            isShowingModal = true
                        }
                        .swipeActions(allowsFullSwipe: false) {
                            Button(action: {
                                print("swipe action")
                            }, label: {
                                Label("action", systemImage: "trash")
                            })
                            .tint(Color(uiColor: Constants.colorRed!))
                            
                            Button(action: {
                                print("swipe action")
                            }, label: {
                                Label("action", systemImage: "info.circle.fill")
                            })
                            .tint(Color(uiColor: Constants.colorGrayLight!))
                        }
                        .swipeActions(edge: .leading) {
                            Button(action: {
                                print("swipe action")
                            }, label: {
                                Label("action", systemImage: "checkmark.circle.fill")
                            })
                            .tint(Color(uiColor: Constants.colorGreen!))
                        }
                        .sheet(isPresented: $isShowingModal) {
                            print("dismissed")
                            isShowingModal = false
                        } content: {
                            NavigationView {
                                DetailsViewSwiftUI(todoItem: todoItem)
                                    .navigationBarItems(leading: Button("Отменить") {
                                        isShowingModal = false
                                    }, trailing: Button("Сохранить"){
                                        isShowingModal = false
                                    })
                            }

                        }
                }
                NewItemCellSwiftUI()
            } header: {
                HStack {
                    Text("Выполнено - 5")
                        .foregroundColor(Color(uiColor: Constants.labelTertiary!))
                    Spacer()
                    Text("Скрыть")
                        .foregroundColor(Color(uiColor: Constants.colorBlue!))
                        .fontWeight(.bold)
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            }
            .navigationTitle("Мои дела" )
            
        }
        .navigationBarTitleDisplayMode(.automatic)
        
    }
}
