//
//  HunchCheckButton.swift
//  Fodinha
//
//  Created by Vinicius Lima on 27/05/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import Foundation
import SwiftUI

struct CheckBox: View {

    @Binding var selectedColor: Color?
    var color: Color

    var body: some View {
        Button(action: { self.selectedColor = self.color }) {
            Text("")
        }   .accentColor(self.color)
    }
}
