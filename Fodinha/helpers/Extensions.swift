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
    static let darkGreen = Color("darkGreen")
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


