//
//  MenuStyles.swift
//  Truquero
//
//  Created by Vinicius Lima on 16/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import Foundation
import SwiftUI

struct PrimaryMenuStyle: MenuStyle {
    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .background(Color.dark5)
            .foregroundColor(Color.dark4)
    }
}
