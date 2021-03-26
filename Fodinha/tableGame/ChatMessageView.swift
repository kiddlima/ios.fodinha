//
//  ChatMessageView.swift
//  Truquero
//
//  Created by Vinicius Lima on 19/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import SwiftUI

struct ChatMessageView: View {
    
    var message: Message
    var players: [Player]
    
    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                
                if !self.message.isSelfMessage() {
                    Text("\(message.username)")
                        .foregroundColor(getPlayerColor(messageSenderId: message.senderId))
                        .font(Font.custom("Avenir-Medium", size: 16))
                }
                
                HStack (alignment: .bottom) {
                    Text("\(message.message)")
                        .foregroundColor(.white)
                        .font(Font.custom("Avenir-Regular", size: 16))
                        .padding(.trailing, 8)
                    
                    Text("\(message.time)")
                        .font(Font.custom("Avenir-Light", size: 14))
                        .foregroundColor(.customLighter2Gray)
                }
            }
            .padding(8)
            .background(self.message.isSelfMessage() ? Color.dark3 : Color.dark5)
            .cornerRadius(10)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .none, alignment:
                self.message.isSelfMessage() ? .trailing : .leading)
    }
    
    func getPlayerColor(messageSenderId: String) -> Color {
        let position = self.players.filter { $0.id == messageSenderId}[0].position
        
        switch position {
        case 1:
            return Color.chatColor1
        case 2:
            return Color.chatColor2
        case 3:
            return Color.chatColor3
        case 4:
            return Color.chatColor4
        case 5:
            return Color.chatColor5
        case 6:
            return Color.chatColor6
        case 7:
            return Color.chatColor7
        default:
            return Color.chatColor8
        }
    }
}

struct ChatMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageView(message: Message(message: "Teste de mensagem no asdfasdfasdfasdfasdfpreview",
                                                   senderId: "Vinicius Lima",
                                                   time: "09:41",
                                                   username: "Vinicius Lima"),
                        players: [Player]())
    }
}
