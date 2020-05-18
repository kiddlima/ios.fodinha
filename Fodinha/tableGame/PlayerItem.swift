//
//  PlayerItem.swift
//  Fodinha
//
//  Created by Vinicius Lima on 07/05/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import SwiftUI

struct PlayerItem: View {
    
    var player: Player
    var isTurn: Bool
    
    var body: some View {
        HStack (spacing: -2){
            VStack (alignment: .leading, spacing: 2){
                Text(player.name!)
                    .font(.callout)
                    .fontWeight(.regular)
                    .foregroundColor(!isTurn ? Color.customLighter2Gray : Color.black)
                Divider()
                HStack{
                    if player.hunch != nil{
                        Text("Faz \(player.hunch!)")
                            .font(.caption)
                            .fontWeight(.light)
                            .foregroundColor(!isTurn ? Color.customLighter2Gray : Color.black)
                    } else {
                        Text("")
                        .font(.caption)
                        .fontWeight(.light)
                            .foregroundColor(Color.customLighter2Gray).hidden()
                    }
                    
                }
            }
            .cornerRadius(2)
            .padding(4)
            .frame(width: 104)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(isTurn ? Color.yellowLight : Color.customLighterGray)
                .shadow(radius: 4)
            )
            
            CardItem(card: player.currentCard)
        }
    }
}

struct PlayerItem_Previews: PreviewProvider {
    static var previews: some View {
        PlayerItem(player: Player(), isTurn: true)
        .previewLayout(.fixed(width: 500, height: 200))
    }
}
