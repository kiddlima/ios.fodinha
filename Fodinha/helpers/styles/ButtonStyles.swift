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
    private let isEnabled: Bool
    
    init(isEnabled: Bool = true) {
            self.isEnabled = isEnabled
        }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
        .font(Font.footnote.weight(.bold))
        .textCase(.uppercase)
        .foregroundColor(Color.dark8)
        .cornerRadius(8)
        .opacity(isEnabled ? 1 : 0.5)
        .padding(.init(top: 12, leading: 48, bottom: 12, trailing: 48))
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
        .background(Color.golden0)
        .cornerRadius(4.0)
    }
}

// Then make a ViewModifier to inject the state
struct GoldenButtonModifier: ViewModifier {
    @Environment(\.isEnabled) var isEnabled
    func body(content: Content) -> some View {
        return content.buttonStyle(GoldenButtonStyle(isEnabled: isEnabled))
    }
}

extension Button {
    func goldenStyle() -> some View {
        ModifiedContent(content: self, modifier: GoldenButtonModifier())
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(Font.footnote.weight(.semibold))
            .textCase(.uppercase)
            .foregroundColor(Color.white)
            .padding(.init(top: 12, leading: 48, bottom: 12, trailing: 48))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
