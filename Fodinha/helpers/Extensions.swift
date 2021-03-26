//
//  ColorExtension.swift
//  Fodinha
//
//  Created by Vinicius Lima on 24/04/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

extension Color{
    static let dark8 = Color("dark-8")
    static let dark7 = Color("dark-7")
    static let dark6 = Color("dark-6")
    static let dark5 = Color("dark-5")
    static let dark4 = Color("dark-4")
    static let dark3 = Color("dark-3")
    
    static let chatColor1 = Color("chatColor1")
    static let chatColor2 = Color("chatColor2")
    static let chatColor3 = Color("chatColor3")
    static let chatColor4 = Color("chatColor4")
    static let chatColor5 = Color("chatColor5")
    static let chatColor6 = Color("chatColor6")
    static let chatColor7 = Color("chatColor7")
    static let chatColor8 = Color("chatColor8")
    
    static let darkWhite = Color("dark-white")
    static let winnerGreen = Color("winner-green")
    static let darkGreen = Color("dark-green")
    
    static let notificationGreen = Color("notification-green")
    static let notificationRed = Color("notification-red")
    
    static let golden0 = Color("golden-0")
    static let facebookBlue = Color("facebook-blue")
    
    static let customDarkGray = Color("customDarkGray")
    static let customBlack = Color("customBlack")
    static let customLighterGray = Color("customLighterGray")
    static let customLighter2Gray = Color("customLighter2Gray")
    static let customLightGray = Color("customLightGray")
    static let lightGreen = Color("lightGreen")
    static let lighterGreen = Color("lighterGreen")
    
    static let tableDefaultGreen = Color("tableDefaultGreen")
    
    static let yellowLight = Color("yellowLight")
}

extension UIColor{
    static let customDarkGray = UIColor(named: "customDarkGray")
    static let customLightGray = UIColor(named: "customLightGray")
    
    static let dark8 = UIColor(named: "dark-8")
    
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif


extension View {
    
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    ///
    ///     Text("Label")
    ///         .isHidden(true)
    ///
    /// Example for complete removal:
    ///
    ///     Text("Label")
    ///         .isHidden(true, remove: true)
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}


