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
    
    init(mockedPlayer: Bool) {
        if mockedPlayer {
            self.name = "Jimmy"
            self.hunch = 1
            self.wins = 1
            
            let card1 = Card(rank: 1, suit: "Paus", value: 2)
            let card2 = Card(rank: 1, suit: "Espada", value: 1)
            let card3 = Card(rank: 1, suit: "Ouro", value: 3)
            let card4 = Card(rank: 1, suit: "Paus", value: 2)
            let card5 = Card(rank: 1, suit: "Paus", value: 2)
            
            self.cards = [Card](arrayLiteral: card1, card2, card3, card4, card5)
        }
    }
    
    var id: String?
    var name: String? = ""
    var active: Bool? = true
    var status: Int? = 0
    var hunch: Int?
    var points: Int?
    var position: Int?
    var wins: Int?
    var cards: [Card]?
    var currentCard: Card?
    var shortName: String? = ""
    var smallRoundWinner: Bool? = false
    var isTurn: Bool? = false
    var choices: [Choice]?
}
