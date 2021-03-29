//
//  Game.swift
//  Fodinha
//
//  Created by Vinicius Lima on 20/04/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import Foundation
import FirebaseAuth

class Game: Decodable, Equatable {
    static func == (lhs: Game, rhs: Game) -> Bool {
        return lhs._id == rhs._id
    }
    
    init(data: [String: Any]) {
        self._id = data["_id"] as? String
        self.smallRoundWinner = data["smallRoundWinner"] as? String
        self.turn = data["turn"] as? String
        self.name = data["name"] as? String
        self.hunchTime = data["hunchTime"] as? Bool
        self.cardAmount = data["cardAmount"] as? Int
        self.createdBy = data["createdBy"] as? String
        self.active = data["active"] as? Bool
        self.winner = data["winner"] as? String
        
        if let playersArray = data["players"] as? NSMutableArray {
            playersArray.forEach { player in
                if let dictPlayer = player as? [String: Any] {
                    self.players?.append(Player(data: dictPlayer))
                }
            }
        }
    }
    
    init() {
        
    }
    
    func isLastPlay() -> Bool {
        var hunchesLeft = 0
        
        self.players!.filter {$0.status == 1} .forEach { player in
            if player.hunch == nil {
                hunchesLeft += 1
            }
        }
        
        return hunchesLeft == 1
    }
    
    func getUnavailableChoice() -> Choice {
        var totalHunches = 0;
        
        self.players!.forEach { player in
            if let hunch = player.hunch {
                totalHunches += hunch
            }
        }
        
        return Choice(number: abs(self.cardAmount! - totalHunches))
    }
    
    func isPlayerInTheGame() -> Bool {
        let uid = Auth.auth().currentUser?.uid
        
        var playerInTheGame = false
        
        self.players?.forEach({ player in
            if uid == player.id && player.status != 0 {
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
    var players: [Player]? = [Player]()
}
