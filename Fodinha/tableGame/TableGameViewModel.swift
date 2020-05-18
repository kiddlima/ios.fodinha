//
//  TableGameViewModel.swift
//  Fodinha
//
//  Created by Vinicius Lima on 08/05/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import SwiftUI

class TableGameViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var game: Game
    @Published var currentPlayer: Player? = Player()
    
    @Published var loading: Bool
    
    var firstLoad: Bool = true
    
    var uid: String?
    
    init(game: Game) {
        self.game = game
        uid = UserDefaults.standard.string(forKey: "uid")
        
        loading = firstLoad
    }
    
    func listenToPlayers(){
        db.collection("game").document(game.gameId!).collection("players").addSnapshotListener { documentSnapshot, error in
        
            self.game.players = []
            
            for snap in (documentSnapshot?.documents)! {
                
                self.game.players.append(Player(document: snap))
            }
            
            self.game.players = self.game.players.sorted(by: { $0.points! > $1.points! })
            
            // Find the current logged player inside the game
            self.game.players.forEach { player in
                if player.playerId == self.uid {
                    self.currentPlayer = player
                }
            }
            
            if self.firstLoad && self.currentPlayer == nil {
                self.addPlayerToGame()
                
                self.firstLoad = false
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                   self.loading = false
                }
            }
        }
    }
    
    func getTurnPlayerName() -> String{
        
        for player in self.game.players {
            if player.playerId == self.game.turn {
                return player.name!
            }
        }
        
        return ""
    }
    
    func isPlayerTurnByPosition(position: Int) -> Bool{
        return game.turn! == getPlayerByPosition(position: position)!.playerId
    }
    
    func isPlayersTurnToHunch() -> Bool{
        return game.hunchTime! && game.turn == uid
    }
    
    func hasPlayerInThatPosition(position: Int) -> Bool{
        for player in self.game.players {
            if player.position == position {
                return true
            }
        }
        
        return false
    }
    
    func getPlayerByPosition(position: Int) -> Player?{
        for player in self.game.players {
            if player.position == position {
                return player
            }
        }
        
        return nil
    }
    
    func shouldShowStartGameButton() -> Bool{
        return !game.active!
    }
    
    // Requests
    
    func setPlayerHunch(hunch: Int){
        guard let url = URL(string: "https://us-central1-fodinha-45405.cloudfunctions.net/hunch") else {
            print("Invalid URL")
            return
        }
        
        let body: [String: Any] = ["gameId": game.gameId!,
                                      "playerRef": game.players[0].playerId,
                                      "hunch": hunch]

        let finalBody = try! JSONSerialization.data(withJSONObject: body)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
        }.resume()
    }
    
    func startGame(gameId: String) {
        guard let url = URL(string: "https://us-central1-fodinha-45405.cloudfunctions.net/startGame") else {
            print("Invalid URL")
            return
        }
        
        let body: [String: String] = ["gameId": gameId]

        let finalBody = try! JSONSerialization.data(withJSONObject: body)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
        }.resume()
    }
    
    func addPlayerToGame(){
        db.collection("game")
        .document(game.gameId!)
        .collection("players")
        .document(uid!)
        .setData(
            [
                "active" : true,
                "hunch": 0,
                "points": 0,
                "wins": 0,
                "name": UserDefaults.standard.string(forKey: "name")!,
                "position": game.players.count - 1
        ])
        {
            error in
            
            if error == nil {
                self.loading = false
            }
        }
    }
    
}
