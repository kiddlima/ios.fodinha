//
//  Player.swift
//  Fodinha
//
//  Created by Vinicius Lima on 25/04/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import Foundation
import SwiftUI

class Player: Decodable {
    
    init() {
        
    }
    
    init(name: String, hunch: Int, wins: Int) {
        self.name = name
        self.hunch = hunch
        self.wins = wins
    }
    
    var id: String?
    var name: String = ""
    var active: Bool? = true
    var status: Int? = 0
    var hunch: Int = -1
    var points: Int?
    var position: Int?
    var wins: Int = -1
    var cards: [Card?]?
    var currentCard: Card?
    var shortName: String? = ""
    var smallRoundWinner: Bool? = false
    var isTurn: Bool? = false
    var choices: [Choice]?
}
