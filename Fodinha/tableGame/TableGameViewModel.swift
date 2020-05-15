//
//  TableGameViewModel.swift
//  Fodinha
//
//  Created by Vinicius Lima on 08/05/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import SwiftUI
import Firebase

class TableGameViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var game: Game
    
    init(game: Game) {
        self.game = game
        
        listenToPlayers()
    }
    
    func listenToPlayers(){
        db.collection("game").document(game.gameId!).collection("players").addSnapshotListener { documentSnapshot, error in
        
            self.game.players = []
            
            for snap in (documentSnapshot?.documents)! {
                
                self.game.players.append(Player(document: snap))
            }
            
            self.game.players = self.game.players.sorted(by: { $0.points! > $1.points! })
        }
    }
    
    func getTurnPlayerName() -> String{
        
        for player in self.game.players {
            if player.playerId == self.game.turn {
                return player.name
            }
        }
        
        return ""
    }
    
    func isPlayersTurnToHunch() -> Bool{
        //TODO COMPARE WITH LOGGED PLAYER
        return game.hunchTime!
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
    
//    func getUserCards() -> [Card]{
//        //TODO
//    }
    
}
