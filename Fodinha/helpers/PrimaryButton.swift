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
            .foregroundColor(Color.customLighter2Gray)
            .font(.callout)
            .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
            .background(RoundedRectangle(cornerRadius: 4, style: .continuous)
                .stroke(Color.customLighter2Gray, lineWidth: 2))
    }
}
