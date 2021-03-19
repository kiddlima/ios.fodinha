//
//  Message.swift
//  Truquero
//
//  Created by Vinicius Lima on 19/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import Foundation
import FirebaseAuth
import SocketIO

struct Message: Hashable, Identifiable {
    
    var id: UUID
    var message: String = ""
    var senderId: String = ""
    var time: String = ""
    var username: String = ""
    
    init(message: String, senderId: String, time: String, username: String) {
        self.id = UUID()
        self.message = message
        self.senderId = senderId
        self.time = time
        self.username = username
    }
    
    func isSelfMessage() -> Bool {
        return self.senderId == Auth.auth().currentUser?.uid
    }
}

struct JoinGameData : SocketData {
    let gameId: String
    let userId: String
    
    func socketRepresentation() -> SocketData {
        return ["gameId": gameId, "userId": userId]
    }
}

struct SendMessageData : SocketData {
    let gameId: String
    let uid: String
    let text: String
    let username: String
    let time: String
    
    func socketRepresentation() -> SocketData {
        return ["gameId": gameId, "uid": uid, "text": text, "username": username, "time": time]
    }
}


