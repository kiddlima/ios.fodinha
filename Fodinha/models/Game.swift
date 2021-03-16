//
//  Game.swift
//  Fodinha
//
//  Created by Vinicius Lima on 20/04/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import Foundation
import FirebaseAuth

class Game: Decodable {
    
    func isLastPlay() -> Bool {
        var hunchesLeft = 0
        
//        self.players.forEach { player in
//            if player.hunch == nil {
//                hunchesLeft += 1
//            }
//        }
        
        return hunchesLeft == 1
    }
    
    func getUnavailableChoice() -> Choice {
        var totalHunches = 0;
        
//        self.players.forEach { player in
//            if let hunch = player.hunch {
//                totalHunches += hunch
//            }
//            
//        }
        
        return Choice(number: abs(self.cardAmount! - totalHunches))
    }
    
    func isPlayerInTheGame() -> Bool {
        var uid = Auth.auth().currentUser?.uid
        
        var playerInTheGame = false
        
        self.players?.forEach({ player in
            if uid == player.id {
                playerInTheGame = true
            }
        })
        
        return playerInTheGame
    }
    
    var _id: String?
    var hasPassword: Bool?
    var active: Bool?
    var cardAmount: Int?
    var createdBy: String?
    var message: String?
    var smallRoundWinner: String?
    var currentHandPosition: Int?
    var currentRound: Int?
    var hunchTime: Bool?
    var name: String?
    var turn: String?
    var winner: String?
    var activePlayers: Int?
    var totalPlayers: Int?
    var someoneLeft: Bool?
    var players: [Player]?
}
