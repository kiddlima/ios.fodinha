//
//  SocketIOManager.swift
//  Fodinha
//
//  Created by Vinicius Lima on 14/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import Foundation
import SocketIO

public class SocketIOManager {
    
    static let sharedInstance = SocketIOManager()
    private var manager = SocketManager(socketURL: URL(string: "https://api.truquero.com.br")!, config: [.log(true), .compress])
    var socket: SocketIOClient!

    init() {
        self.socket = self.manager.defaultSocket
        
        self.socket.on(clientEvent: .connect) {data, ack in
        }
        
        self.socket.on(clientEvent: .error) {data, ack in
            print(data)
        }
        
        self.socket.on("attGame") {data, ack in
            print(data)
        }
        
        self.socket.connect()
    }
}
