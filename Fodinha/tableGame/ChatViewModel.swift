//
//  ChatViewModel.swift
//  Truquero
//
//  Created by Vinicius Lima on 19/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import Foundation
import SwiftUI
import SocketIO
import FirebaseAuth

class ChatViewModel: ObservableObject {
    
    @Published var messages = [Message]()
    
    let socket = SocketIOManager.sharedInstance.socket!
    
    var gameId: String = ""
    
    let uid = (Auth.auth().currentUser?.uid)!
    let username = (Auth.auth().currentUser?.displayName)!
    
    init (gameId: String) {
        self.gameId = gameId
        self.socket.emit("joinGame", JoinGameData(gameId: gameId, userId: self.uid))
            
        self.socket.on("messageToGame") { data, ack in
            if let arr = data as? [[String: Any]] {
                let username = arr[0]["username"] as? String
                let uid = arr[0]["uid"] as? String
                let time = arr[0]["time"] as? String
                let text = arr[0]["text"] as? String
                
                self.messages.append(Message(message: text!, senderId: uid!, time: time!, username: username!))
            }
        }
    }
    
    func sendMessage(message: String) {
        let now = Date()
        let time =  "\(Calendar.current.component(.hour, from: now)):\(Calendar.current.component(.minute, from: now))"
        
        self.socket.emit("messageToServer", SendMessageData(
                            gameId: self.gameId,
                            uid: self.uid,
                            text: message,
                            username: username,
                            time: time))
    }
}
