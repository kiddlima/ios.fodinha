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
    
    init(message: Message) {
        self.message = message
    }
    
    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                
                if !self.message.isSelfMessage() {
                    Text("\(message.username)")
                        .foregroundColor(.white)
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
}

struct ChatMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageView(message: Message(message: "Teste de mensagem no asdfasdfasdfasdfasdfpreview",
                                                   senderId: "Vinicius Lima",
                                                   time: "09:41",
                                                   username: "Vinicius Lima"))
    }
}
