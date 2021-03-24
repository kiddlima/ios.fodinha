//
//  AvailableGamesViewModel.swift
//  Fodinha
//
//  Created by Vinicius Lima on 20/04/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import SwiftUI

class AvailableGamesViewModel: ObservableObject {
    
    let socket = SocketIOManager.sharedInstance.socket!
    
    @Published var loading: Bool
    
    var selectedGame: Game?
    
    @Published var games: [Game] = []
    @Published var error: String?
    
    init() {
        self.loading = true
        
        NetworkHelper().getGames(networkDelegate: self)
        
        listenToGames()
    }
    
    func listenToGames(){
        self.socket.on(clientEvent: .connect) { data, act in
            
            self.socket.emit("joinHome")
        
            self.socket.on("attGame") { data, ack in
                NetworkHelper().getGames(networkDelegate: self)
            }
        }
    }
    
    func removeListener() {
        self.socket.off("attGame")
    }
}

extension AvailableGamesViewModel: NetworkRequestDelegate {
    
    func fail(errorMessage: String) {
        withAnimation {
            self.loading = false
        }
    }
    
    func success(response: Any?) {
        withAnimation {
            self.loading = false
        }
        
        self.games = response as? [Game] ?? []
    }
    
}
