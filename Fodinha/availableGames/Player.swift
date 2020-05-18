//
//  Player.swift
//  Fodinha
//
//  Created by Vinicius Lima on 25/04/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct Player: Identifiable {
    
    init(document: QueryDocumentSnapshot) {
        self.active = document.get("active") as! Bool
        self.playerId = document.documentID
        self.hunch = document.get("hunch") as? Int
        self.points = document.get("points") as? Int
        self.position = document.get("position") as? Int
        self.wins = document.get("wins") as? Int
        self.name = document.get("name") as? String
        
        let cards = document.data()["cards"] as? [Any]
        
        self.cards = []
        
        cards?.forEach { card in
            let cardObject = card as! [String: Any]
            
            self.cards.append(
                Card(rank: cardObject["rank"] as? Int,
                     suit: cardObject["suit"] as? String,
                     value: cardObject["value"] as? Int))
        }
        
        let currentCardObject = document.data()["currentCard"] as? [String: Any]
        
        if currentCardObject != nil {
            self.currentCard = Card(
                rank: currentCardObject!["rank"] as? Int,
                suit: currentCardObject!["suit"] as? String,
                value: currentCardObject!["value"] as? Int)
        }
    }
    
    init() {
        
    }
    
    var id: ObjectIdentifier?
    var playerId: String = ""
    var name: String? = ""
    var active: Bool = false
    var hunch: Int?
    var points: Int?
    var position: Int?
    var wins: Int?
    var cards: [Card?] = []
    var currentCard: Card?
}
