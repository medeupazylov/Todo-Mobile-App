//
//  NewItemCellSwiftUI.swift
//  TodoAppSwifftUI
//
//  Created by Medeu Pazylov on 19.07.2023.
//

import SwiftUI

struct NewItemCellSwiftUI: View {
    var body: some View {
        Text("Новое дело")
            .foregroundColor(Color.init(uiColor: Constants.labelTertiary!))
            .position(CGPoint(x: 80, y: 15))
            
    }
}

struct NewItemCellSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        NewItemCellSwiftUI()
    }
}
