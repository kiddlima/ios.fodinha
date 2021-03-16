//
//  GameListSocket.swift
//  Fodinha
//
//  Created by Vinicius Lima on 03/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import Foundation
import SocketIO

class GameListSocket {
    
    let socket = SocketIOManager.sharedInstance.socket!
    
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

extension GameListSocket: NetworkRequestDelegate {
    func fail(errorMessage: String) {
        
    }
    
    func success(response: Any?) {
        
    }
}
