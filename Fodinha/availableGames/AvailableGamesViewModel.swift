//
//  AvailableGamesViewModel.swift
//  Fodinha
//
//  Created by Vinicius Lima on 20/04/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class AvailableGamesViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    let socket = SocketIOManager.sharedInstance.socket!
    
    @Published var games: [Game] = []
    @Published var error: String?
    
    init() {
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
}

extension AvailableGamesViewModel: NetworkRequestDelegate {
    
    func fail(errorMessage: String) {
        error = errorMessage
    }
    
    func success(response: Any?) {
        self.games = response as? [Game] ?? []
        print(self.games)
    }
    
}
