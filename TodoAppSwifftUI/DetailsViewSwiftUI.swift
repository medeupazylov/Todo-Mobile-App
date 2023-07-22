//
//  DetailsViewSwiftUI.swift
//  TodoAppSwifftUI
//
//  Created by Medeu Pazylov on 20.07.2023.
//

import SwiftUI

struct DetailsViewSwiftUI: View {
    var todoItem: TodoItem
    
    var body: some View {
        Text(todoItem.text)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Дело")
            
    }
}

//struct DetailsViewSwiftUI_Previews: PreviewProvider {
//    static var previews: some View {
//        @Binding var todoItem: TodoItem = projectedValue(text: "1231", priority: .high, isDone: false)
//        DetailsViewSwiftUI(todoItem: todoItem)
//    }
//}
