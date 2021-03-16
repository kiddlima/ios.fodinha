//
//  SelectedButton.swift
//  Fodinha
//
//  Created by Vinicius Lima on 26/05/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import Foundation
import SwiftUI

struct SelectedButton: ButtonStyle {
    var selected: Bool
    var disabled: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(self.disabled ? Color.customDarkGray : Color.customLighter2Gray)
            .font(.callout)
            .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
            .background(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .stroke(self.disabled ? Color.customDarkGray : Color.customLighterGray)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(self.disabled ? Color.customBlack : Color.customLighterGray.opacity(self.selected ? 1 : 0))
            ))
    }
}

