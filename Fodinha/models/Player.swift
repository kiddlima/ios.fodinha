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
            self.points = 0

        }
    }
    
    init(mockedPlayer: Bool, points: Int) {
        if mockedPlayer {
            self.name = "Jimmy"
            self.hunch = 1
            self.wins = 1
            self.points = points

        }
    }
    
    
    
    init(data: [String: Any]) {
        self.status = data["status"] as? Int
        self.id = data["id"] as? String
        self.points = data["points"] as? Int
        self.position = data["position"] as? Int
        self.name = data["name"] as? String
        self.wins = data["wins"] as? Int
        self.hunch = data["hunch"] as? Int
        
        if let dictCurrentCard = data["currentCard"] as? [String: Any] {
            self.currentCard = Card(data: dictCurrentCard)
        }
        
        if let cardsArray = data["cards"] as? NSMutableArray {
            cardsArray.forEach { card in
                if let dictCard = card as? [String: Any] {
                    self.cards?.append(Card(data: dictCard))
                }
            }
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
    var cards: [Card]? = [Card]()
    var currentCard: Card?
    var shortName: String? = ""
    var smallRoundWinner: Bool? = false
    var isTurn: Bool? = false
    var choices: [Choice]?
}
