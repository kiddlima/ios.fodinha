//
//  Game.swift
//  Fodinha
//
//  Created by Vinicius Lima on 20/04/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Game: Identifiable {
    
    init(document: QueryDocumentSnapshot) {
        self.gameId = document.documentID as String
        self.active = document.get("active") as? Bool
        self.name = document.get("name") as? String
        self.hunchTime = document.get("hunchTime") as? Bool
        self.winner = document.get("winner") as? String
        self.turn = document.get("turn") as? String
        self.currentRound = document.get("currentRound") as? Int
        self.cardAmount = document.get("cardAmount") as? Int
        self.createdBy = document.get("createdBy") as? String
    }
    
    init(document: DocumentSnapshot) {
       self.gameId = document.documentID as String
       self.active = document.get("active") as? Bool
       self.name = document.get("name") as? String
       self.hunchTime = document.get("hunchTime") as? Bool
       self.winner = document.get("winner") as? String
       self.turn = document.get("turn") as? String
       self.currentRound = document.get("currentRound") as? Int
       self.cardAmount = document.get("cardAmount") as? Int
       self.createdBy = document.get("createdBy") as? String
    }
    
    init() {

    }
    
    var id: ObjectIdentifier?
    var gameId: String?
    var active: Bool?
    var cardAmount: Int?
    var createdBy: String?
    var currentHandPosition: Int?
    var currentRound: Int?
    var hunchTime: Bool?
    var name: String?
    var turn: String?
    var winner: String?
    var activePlayers: Int?
    var totalPlayers: Int?
    var players: [Player] = []
}
