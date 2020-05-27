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
import FirebaseFunctions

class TableGameViewModel: ObservableObject {
    
    lazy var functions = Functions.functions()
    let db = Firestore.firestore()
    var uid: String?
    
    @Published var game: Game?
    @Published var currentPlayer: Player?
    @Published var smallRoundWinner: Player?
    
    var selectedCard: Card?
    
    @Published var userHunchChoice: Int?
    
    @Published var loadingStartGame: Bool = false
    @Published var loadingPlay: Bool = false
    var firstLoad: Bool = true
    var isPlayerInTheGameAlready: Bool = false

    init(gameId: String) {
        uid = Auth.auth().currentUser?.uid
        
        db.settings.isPersistenceEnabled = false
        
        self.listenToGame(gameId: gameId)
    }
    
    func listenToGame(gameId: String){
        db.collection("game").document(gameId).addSnapshotListener { (documentSnapshot, error) in
            if error == nil {
                self.game = Game(document: documentSnapshot!)
                
                self.listenToPlayers()
            }
        }
    }
    
    func listenToPlayers(){
        db.collection("game").document(game!.gameId!).collection("players").addSnapshotListener { documentSnapshot, error in
        
            self.game!.players = []
            
            for snap in (documentSnapshot?.documents)! {
                
                self.game!.players.append(Player(document: snap))
            }
            
            self.game!.players = self.game!.players.sorted(by: { $0.points! > $1.points! })
            
            // Find the current logged player inside the game
            for (index, player) in self.game!.players.enumerated() {
                if player.playerId == self.uid {
                    self.currentPlayer = player
                    
                    if self.game!.cardAmount == 1 {
                        self.game!.players[index].currentCard = nil
                    }
                    
                    self.isPlayerInTheGameAlready = true
                }
            }
            
            if self.game!.smallRoundWinner != nil {
                self.smallRoundWinner = self.getSmallWinnerPlayer()
            } else {
                self.smallRoundWinner = nil
            }
            
            self.setTurnAndWinnerPlayer()
            
            if !self.isPlayerInTheGameAlready {
                self.addPlayerToGame()
            }
        }
    }
    
    func selectCard(position: Int){
        // Unselect previous card
        for index in 0 ..< ((currentPlayer?.cards.count)!) {
            currentPlayer?.cards[index]?.selected = false
        }
        
        // Select new card
        currentPlayer?.cards[position]?.selected = true
        
        selectedCard = currentPlayer?.cards[position]
    }
    
    func getTurnPlayerName() -> String{
        
        for player in self.game!.players {
            if player.playerId == self.game!.turn {
                return player.name!
            }
        }
        
        return ""
    }
    
    func setTurnAndWinnerPlayer() {
        for index in 0 ..< ((game!.players.count)) {
            game!.players[index].isTurn = game!.players[index].playerId == game!.turn
            
            if smallRoundWinner != nil {
                game!.players[index].smallRoundWinner = game!.players[index].playerId == smallRoundWinner?.playerId
            }
        }
    }
    
    func isPlayersTurnToHunch() -> Bool{
        return
            game!.hunchTime! &&
            game!.turn == uid &&
            currentPlayer?.hunch == nil
    }
    
    func hasPlayerInThatPosition(position: Int) -> Bool{
        for player in self.game!.players {
            if player.position == position {
                return true
            }
        }
        
        return false
    }
    
    func getPlayerByPosition(position: Int) -> Player?{
        for player in self.game!.players {
            if player.position == position {
                return player
            }
        }
        
        return nil
    }
    
    func shouldShowStartGameButton() -> Bool{
        return !game!.active!
    }
    
    func isPlayersTurnToPlay() -> Bool{
        return !game!.hunchTime! && game!.turn == currentPlayer?.playerId
    }
    
    func getSmallWinnerPlayer() -> Player? {
        for player in game!.players {
            if player.playerId == game!.smallRoundWinner {
                return player
            }
        }
        
        return nil
    }
    
    // Requests
    func setPlayerHunch(hunch: Int){
        functions.httpsCallable("hunch").call(
            ["gameId": game?.gameId! as Any,
             "playerRef": currentPlayer?.playerId as Any,
             "hunch": hunch]) { (result, error) in
                
        }
    }
    
    func startGame(gameId: String) {
        self.loadingStartGame = true
        
        functions.httpsCallable("startGame").call(
            ["gameId": gameId as Any]) { (result, error) in
                
        }
    }
    
    func playCard() {
        self.loadingPlay = true
        
        let cardObject: [String: Any] =
            ["rank": selectedCard!.rank! as Int,
            "suit": selectedCard!.suit! as String,
            "value": selectedCard!.value! as Int]
        
        functions.httpsCallable("startGame").call(
            ["gameId": game!.gameId!,
             "card": cardObject]) { (result, error) in
                
        }
    }
    
    func addPlayerToGame(){
        functions.httpsCallable("join").call(
            ["gameId": game!.gameId!]) { (result, error) in
                if let error = error as NSError? {
                  if error.domain == FunctionsErrorDomain {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                  }
                  // ...
                }
                
                if let data = (result?.data as? [String: Any]) {
                    print(data)
            }
        }
        
//        db.collection("game")
//        .document(game!.gameId!)
//        .collection("players")
//        .document(uid!)
//        .setData(
//            [
//                "active" : true,
//                "points": 0,
//                "wins": 0,
//                "name": UserDefaults.standard.string(forKey: "name")!,
//                "position": game!.players.count
//        ])
//        {
//            error in
//
//            if error == nil {
//
//            }
//        }
    }
    
}
