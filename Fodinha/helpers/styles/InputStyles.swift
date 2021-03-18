//
//  InputStyles.swift
//  Truquero
//
//  Created by Vinicius Lima on 16/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import Foundation
import SwiftUI

struct PrimaryInput: TextFieldStyle {
    @State var invalid: Bool = false
    
    init(invalid: Bool) {
        self.invalid = invalid
    }
    
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
        .padding(16)
        .font(Font.custom("Avenir-Regular", size: 16))
        .foregroundColor(.white)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(self.invalid ? Color.notificationRed : Color.white, lineWidth: 1))
    }
}
