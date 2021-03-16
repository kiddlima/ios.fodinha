//
//  TableDesignHelper.swift
//  Fodinha
//
//  Created by Vinicius Lima on 26/05/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class TableDesignHelper {
    
    static func getPlayerBgColor(player: Player) -> Color {
        if player.smallRoundWinner! {
            return Color.lighterGreen
        }
        
        if player.isTurn! {
            return Color.yellowLight
        }
        
        return Color.customLighterGray
    }
    
    static func getPlayerTextColor(player: Player) -> Color {
        if player.isTurn! || player.smallRoundWinner! {
            return Color.black
        }
        
        return Color.customLighter2Gray
    }
    
}
