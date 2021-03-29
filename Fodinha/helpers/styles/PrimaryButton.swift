//
//  PrimaryButton.swift
//  Fodinha
//
//  Created by Vinicius Lima on 18/05/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import Foundation
import SwiftUI

struct PrimaryButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .font(Font.custom("Avenir-Medium", size: 16))
            .textCase(.uppercase)
            .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .background(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(Color.white.opacity(0))
                .overlay(
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .stroke(Color.white, lineWidth: 2)
                )
            )
    }
}

