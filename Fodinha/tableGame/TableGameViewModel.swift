//
//  TableGameViewModel.swift
//  Fodinha
//
//  Created by Vinicius Lima on 08/05/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import SwiftUI
import Firebase
import SwiftUI
import FirebaseAuth

class TableGameViewModel: ObservableObject {
    
//    lazy var functions = Functions.functions()
//    let db = Firestore.firestore()
    var uid: String?
    
    @Published var game: Game?
    @Published var currentPlayer: Player?
    @Published var smallRoundWinner: Player?
    
    @Published var choices: [Choice] = []
    
    var selectedCard: Card?
    
    @Published var userHunchChoice: Int = -2
    
    @Published var loadingStartGame: Bool = false
    @Published var loadingPlay: Bool = false
    var firstLoad: Bool = true
    var isPlayerInTheGameAlready: Bool = false
    
    init(gameId: String) {
        uid = Auth.auth().currentUser?.uid
        
        
        
//        db.settings.isPersistenceEnabled = false
        
//        self.listenToGame(gameId: gameId)
    }
    
    func listenToGame(gameId: String){
//        db.collection("game").document(gameId).addSnapshotListener { (documentSnapshot, error) in
//            if error == nil {
//                self.game = Game(document: documentSnapshot!)
//
//                self.listenToPlayers()
//            }
//        }
    }
    
    func listenToPlayers(){
//        db.collection("game").document(game!.gameId!).collection("players").addSnapshotListener { documentSnapshot, error in
            
//            self.game!.players = []
//
//            for snap in (documentSnapshot?.documents)! {
//
////                self.game!.players.append(Player(document: snap))
//            }
//
//            self.game!.players = self.game!.players.sorted(by: { $0.points! > $1.points! })
//
//            // Find the current logged player inside the game
//            for (index, player) in self.game!.players.enumerated() {
//                if player.playerId == self.uid {
//                    self.currentPlayer = player
//
//                    if self.choices.isEmpty {
//                        self.populateChoices(cardAmount: self.game!.cardAmount!)
//                    }
//
//                    if self.game!.cardAmount == 1 {
//                        self.game!.players[index].currentCard = nil
//                    }
//
//                    self.isPlayerInTheGameAlready = true
//                }
//            }
//
//            if self.game!.smallRoundWinner != nil {
//                self.smallRoundWinner = self.getSmallWinnerPlayer()
//            } else {
//                self.smallRoundWinner = nil
//            }
//
//            self.setTurnAndWinnerPlayer()
//
//            if !self.isPlayerInTheGameAlready {
//                self.addPlayerToGame()
//            }
//        }
    }
    
    func populateChoices(cardAmount: Int){
        var unavailableChoice: Choice?
        
        if game!.cardAmount != 1 {
            if game!.isLastPlay() {
                unavailableChoice = game!.getUnavailableChoice()
            }
        }
        
        
        for i in 0...cardAmount {
            let choice = Choice(number: i)
            
            if unavailableChoice != nil {
                if unavailableChoice!.number == choice.number {
                    choice.available = false
                }
            }
            
            self.choices.append(choice)
        }
    }
    
    func setChoice(selectedChoice: Choice){
        var newChoices: [Choice] = []
        
        for choice in self.choices {
//            let newChoice = Choice(number: choice.number)
            
//            newChoice.selected = selectedChoice.number == choice.number
//            newChoice.available = choice.available
//
//            newChoices.append(newChoice)
        }
        
        self.choices = newChoices
    }
    
    func selectCard(position: Int){
        // Unselect previous card
//        for index in 0 ..< ((currentPlayer?.cards.count)!) {
//            currentPlayer?.cards[index]?.selected = false
//        }
        
        // Select new card
//        currentPlayer?.cards[position]?.selected = true
        
//        selectedCard = currentPlayer?.cards[position]
    }
    
    func getTurnPlayerName() -> String{
        
//        for player in self.game!.players {
//            if player.playerId == self.game!.turn {
//                return player.name!
//            }
//        }
        
        return ""
    }
    
    func setTurnAndWinnerPlayer() {
//        for index in 0 ..< ((game!.players.count)) {
//            game!.players[index].isTurn = game!.players[index].playerId == game!.turn
//
//            if smallRoundWinner != nil {
//                game!.players[index].smallRoundWinner = game!.players[index].playerId == smallRoundWinner?.playerId
//            }
//        }
    }
    
    func isPlayersTurnToHunch() -> Bool{
        return
            game!.hunchTime! &&
            game!.turn == uid &&
            currentPlayer != nil &&
            !choices.isEmpty &&
            currentPlayer?.hunch == nil
    }
    
    func hasPlayerInThatPosition(position: Int) -> Bool{
//        for player in self.game!.players {
//            if player.position == position {
//                return true
//            }
//        }
        
        return false
    }
    
    func getPlayerByPosition(position: Int) -> Player?{
//        for player in self.game!.players {
//            if player.position == position {
//                return player
//            }
//        }
        
        return nil
    }
    
    func shouldShowStartGameButton() -> Bool{
        return !game!.active!
    }
    
    func isPlayersTurnToPlay() -> Bool{
        return true
//        return !game!.hunchTime! && game!.turn == currentPlayer?.playerId
    }
    
    func getSmallWinnerPlayer() -> Player? {
//        for player in game!.players {
//            if player.playerId == game!.smallRoundWinner {
//                return player
//            }
//        }
        
        return nil
    }
    
    // Requests
    func setPlayerHunch(){
        var selectedChoice: Choice?
        
//        for choice in self.choices {
//            if choice.selected {
//                selectedChoice = choice
//            }
//        }
        
//        functions.httpsCallable("hunch").call(
//            ["gameId": game?.gameId! as Any,
//             "playerRef": currentPlayer?.playerId as Any,
//             "hunch": selectedChoice!.number]) { (result, error) in
//                self.choices = []
//        }
    }
    
    func startGame(gameId: String) {
        self.loadingStartGame = true
        
//        functions.httpsCallable("startGame").call(
//        ["gameId": gameId as Any]) { (result, error) in
//
//        }
    }
    
    func playCard() {
//        self.loadingPlay = true
//
//        let cardObject: [String: Any] =
//            ["rank": selectedCard!.rank! as Int,
//             "suit": selectedCard!.suit! as String,
//             "value": selectedCard!.value! as Int]
//
//        functions.httpsCallable("startGame").call(
//            ["gameId": game!.gameId!,
//             "card": cardObject]) { (result, error) in
//
//        }
    }
    
    func addPlayerToGame(){
//        functions.httpsCallable("join").call(
//        ["gameId": game!.gameId!]) { (result, error) in
//            if let error = error as NSError? {
//                if error.domain == FunctionsErrorDomain {
//                    let code = FunctionsErrorCode(rawValue: error.code)
//                    let message = error.localizedDescription
//                    let details = error.userInfo[FunctionsErrorDetailsKey]
//                }
//                // ...
//            }
//
//            if let data = (result?.data as? [String: Any]) {
//                print(data)
//            }
//        }
    }
    
}
