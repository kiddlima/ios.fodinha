//
//  WinnerModal.swift
//  Truquero
//
//  Created by Vinicius Lima on 28/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import SwiftUI

struct WinnerModal: View {
    
    var winner: Player
    var players: [Player]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image("")
                Text("\(winner.name!) venceu o jogo!")
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.top, 16)
            .padding(.leading, 16)
            .padding(.trailing, 16)
            .background(Color.dark3)
            
            VStack {
                
            }
            
            HStack {
                
            }
        }
        .frame(width: 600, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .background(Color.dark7)
        .cornerRadius(20)
    }
}

struct WinnerModal_Previews: PreviewProvider {
    static var previews: some View {
        let player = Player(mockedPlayer: true)
        let player2 = Player(mockedPlayer: true)
        
        WinnerModal(winner: Player(mockedPlayer: true), players: [Player](arrayLiteral: player, player2))
            .previewLayout(.fixed(width: 1068, height: 420))
    }
}
