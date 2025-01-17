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
    
    var uid = Auth.auth().currentUser?.uid
    
    @Published var game: Game = Game()
    
    @Published var players: [Player]?
    @Published var winnerPlayers: [Player] = [Player]()
    @Published var confirmedPlayers: [String]?
    
    @Published var timeRemainingToPlay = 40
    
    @Published var activeMenu = [
        false, false, false
    ]
    
    @Published var player1: Player?
    @Published var player2: Player?
    @Published var player3: Player?
    @Published var player4: Player?
    @Published var player5: Player?
    @Published var player6: Player?
    @Published var player7: Player?
    
    @Published var currentPlayer = Player()
    @Published var currentPlayerCards = [Card?]()
    @Published var toShowCards = [Card]()
    @Published var showGhostView = false
    
    @Published var showHunchView = false
    @Published var showLeaveGameModal = false
    @Published var showWinnerModal = false
    @Published var showWinnerModa2 = true
    
    @Published var choices: [Choice] = []
    
    var selectedCard: Card?
    
    @Published var loadingStartGame: Bool = false
    @Published var loadingLeaveGame: Bool = false
    @Published var loadingRematch: Bool = false
    @Published var loadingPlay: Bool = false
    
    @Published var loadingGame: Bool = true
    
    var firstLoad: Bool = true
    
    let socket = SocketIOManager.sharedInstance.socket!
    
    init(gameId: String) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.startApp), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopApp), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NetworkHelper().getGame(gameId: gameId) { game, error in
            if error == nil {
                self.onGameUpdate(game: game!)
            }
        }
        
        self.socket.on("updateGame") { (data, ack) in
            if let gameDict = data[0] as? [String: Any] {
                self.onGameUpdate(game: Game(data: gameDict))
            }
        }
    }
    
    @objc func stopApp() {
        self.loadingGame = true
    }
    
    @objc func startApp() {
        if let id = game._id {
            self.loadingGame = true
            
            NetworkHelper().getGame(gameId: id) { game, error in
                if error == nil {
                    self.onGameUpdate(game: game!)
                }
                
                self.loadingGame = false
            }
        }
    }
    
    func getRelativePosition(nextSelfPlayerPosition: Int) -> Int {
        if nextSelfPlayerPosition >= 8 {
           return nextSelfPlayerPosition - 8
        }
        
        return nextSelfPlayerPosition
    }
    
    func onGameUpdate(game: Game) {
        withAnimation(.easeOut(duration: 0.3)) {
            self.game = game
            self.players = game.players
            self.timeRemainingToPlay = game.timer ?? 40
            self.confirmedPlayers = game.confirmedPlayers
            self.winnerPlayers = game.players!
            
            withAnimation {
                self.loadingGame = false
            }
            
            if game.winner != nil {
                if !self.players!.isEmpty {
                    self.players?.sort { $0.points! < $1.points! }
                    
                    self.activeMenu = [false, false, false]
                    self.showWinnerModal = true
                }
            } else {
                self.showWinnerModal = false
            }
            
            game.players?.forEach({ player in
                if player.id == uid {
                    self.currentPlayer = player
                    
                    //Mostra a view para jogar a carta
                    if !(game.hunchTime ?? true) && self.uid == game.turn {
                        self.showGhostView = true
                    } else {
                        self.showGhostView = false
                    }
                    
                    checkPlayerStatus(player: self.currentPlayer)
                    
                    self.currentPlayerCards = player.cards ?? [Card]()
                
                    if self.isPlayersTurnToHunch() {
                        if self.choices.isEmpty {
                            self.populateChoices(cardAmount: game.cardAmount!)
                            
                            self.showHunchView = true
                        }
                    } else {
                        self.showHunchView = false
                    }
                }
            })
        
            if let players = game.players {
                if positionHasPlayer(position: 1) {
                    player1 = players[getRelativePosition(nextSelfPlayerPosition: self.currentPlayer.position! + 1)]
                    checkPlayerStatus(player: player1)
                } else {
                    player1 = nil
                }
                
                if positionHasPlayer(position: 2) {
                    player2 = players[getRelativePosition(nextSelfPlayerPosition: self.currentPlayer.position! + 2)]
                    checkPlayerStatus(player: player2)
                } else {
                    player2 = nil
                }
                
                if positionHasPlayer(position: 3) {
                    player3 = players[getRelativePosition(nextSelfPlayerPosition: self.currentPlayer.position! + 3)]
                    checkPlayerStatus(player: player3)
                } else {
                    player3 = nil
                }
                
                if positionHasPlayer(position: 4) {
                    player4 = players[getRelativePosition(nextSelfPlayerPosition: self.currentPlayer.position! + 4)]
                    checkPlayerStatus(player: player4)
                } else {
                    player4 = nil
                }
                
                if positionHasPlayer(position: 5) {
                    player5 = players[getRelativePosition(nextSelfPlayerPosition: self.currentPlayer.position! + 5)]
                    checkPlayerStatus(player: player5)
                } else {
                    player5 = nil
                }
                
                if positionHasPlayer(position: 6) {
                    player6 = players[getRelativePosition(nextSelfPlayerPosition: self.currentPlayer.position! + 6)]
                    checkPlayerStatus(player: player6)
                } else {
                    player6 = nil
                }
                
                if positionHasPlayer(position: 7) {
                    player7 = players[getRelativePosition(nextSelfPlayerPosition: self.currentPlayer.position! + 7)]
                    checkPlayerStatus(player: player7)
                } else {
                     player7 = nil
                }
            }
            
            withAnimation {
                self.loadingGame = false
            }
        }
    }
     
    func checkPlayerStatus(player: Player?) {
        player?.isTurn = self.game.turn == player?.id
        player?.smallRoundWinner = self.game.smallRoundWinner == player?.id
    }
    
    func positionHasPlayer (position: Int) -> Bool {
        if let currentPlayerPosition = self.currentPlayer.position {
            return (getRelativePosition(nextSelfPlayerPosition: currentPlayerPosition + position)) <= self.players!.count - 1
        }
        
        return false
    }
    
    func populateChoices(cardAmount: Int){
        var unavailableChoice: Choice?

        if self.game.cardAmount != 1 {
            if self.game.isLastPlay() && (self.players?.count ?? 1) > 2 {
                unavailableChoice = self.game.getUnavailableChoice()
            }
        }

        for i in 0...cardAmount {
            let choice = Choice(number: i)

            if let notAvailableChoice = unavailableChoice {
                if notAvailableChoice.number == choice.number {
                    choice.available = false
                }
            }

            self.choices.append(choice)
        }
    }
    
    func setChoice(selectedChoice: Choice){
        var newChoices: [Choice] = []
        
        for choice in self.choices {
            let newChoice = Choice(number: choice.number!)
            
            newChoice.selected = selectedChoice.number == choice.number
            newChoice.available = choice.available

            newChoices.append(newChoice)
        }
        
        self.choices = newChoices
    }
    
    func removeChoice(){
        self.choices.forEach { choice in
            choice.selected = false
        }
    }
    
    func isPlayersTurnToHunch() -> Bool{
        return
            (game.hunchTime ?? false) &&
            game.turn == uid &&
            currentPlayer.hunch == nil
    }
    
//    func shouldShowStartGameButton() -> Bool{
//        return !game!.active!
//    }
    
    // Requests
    func setPlayerHunch(){
        var selectedChoice: Choice?
        
        for choice in self.choices {
            if choice.selected! {
                selectedChoice = choice
            }
        }
        
        withAnimation {
            self.showHunchView = false
        }
            
        NetworkHelper().makeHunch(gameId: self.game._id!, hunch: selectedChoice!.number!) { error in
            if error == nil {
                //TODO: Show error message
                self.choices = [Choice]()
            } else {
                self.choices = [Choice]()
            }
        }
    }
    
    func startGame() {
        self.loadingStartGame = true
            
        NetworkHelper().startGame(gameId: self.game._id!) { error in
            if error != nil {
                //TODO: Show error creating game
            }
        }

    }
    
    func playCard(card: Card) {
        self.currentPlayer.currentCard = card
        
        NetworkHelper().playCard(gameId: self.game._id!, card: card) { error in
            if error == nil {
                print()
            }
        }
    }
    
    func leaveGame (callback: @escaping (String?) -> Void) {
        NetworkHelper().leaveGame(gameId: self.game._id!) { error in
            self.socket.emit("leaveGame", self.game._id!)
            self.socket.off("updateGame")
            self.socket.emit("joinHome")
            callback(error)
        }
    }
}
