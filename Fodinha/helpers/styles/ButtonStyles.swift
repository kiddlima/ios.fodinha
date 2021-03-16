//
//  ButtonStyles.swift
//  Fodinha
//
//  Created by Vinicius Lima on 15/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import Foundation
import SwiftUI

struct GoldenButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
        .font(Font.footnote.weight(.bold))
        .textCase(.uppercase)
        .foregroundColor(Color.dark8)
        .padding(.init(top: 12, leading: 48, bottom: 12, trailing: 48))
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
        .background(Color.golden0)
    }
}
