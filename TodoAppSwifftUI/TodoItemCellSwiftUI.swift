//
//  TodoItemCellSwiftUI.swift
//  TodoAppSwifftUI
//
//  Created by Medeu Pazylov on 19.07.2023.
//

import SwiftUI

struct TodoItemCellSwiftUI: View {
    var model: TodoItem 
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(Color.init(uiColor: Constants.supportSeparator!))
                
            VStack (alignment: .leading) {
                Text(model.text)
                HStack (spacing: 2.0){
                    Image (systemName: "calendar")
                        .foregroundColor(Color.init(uiColor: Constants.labelTertiary!))
                    Text("14 июня")
                        .foregroundColor(Color.init(uiColor: Constants.labelTertiary!))
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .resizable()
                .frame(width: 7, height: 12)
            
        }
        
       
    }
}

struct TodoItemCellSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        TodoItemCellSwiftUI(
            model: TodoItem(
                text: "Clean the house and go to trash",
                priority: .high,
                isDone: false
            )
        )
    }
}





