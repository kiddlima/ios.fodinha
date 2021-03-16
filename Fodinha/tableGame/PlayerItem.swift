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
    
    var body: some View {
        HStack (spacing: -2){
            VStack (alignment: .leading, spacing: 2){
                Text(player.shortName!)
                    .font(.callout)
                    .fontWeight(.regular)
                    .foregroundColor(TableDesignHelper.getPlayerTextColor(player: self.player))
                Divider()
                HStack{
                    if player.hunch != nil{
                        Text("Faz \(player.hunch!)")
                            .font(.caption)
                            .fontWeight(.light)
                            .foregroundColor(TableDesignHelper.getPlayerTextColor(player: self.player))
                        
                        Spacer()
                        
                        HStack (spacing: 1.5) {
                            ForEach (0 ..< player.wins!, id: \.self) { wins in
                                Circle()
                                    .frame(width: 8, height: 8)
                                    .foregroundColor(Color.lightGreen)
                            }
                        }.padding(.trailing, 4)
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
            .animation(.easeIn)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(TableDesignHelper.getPlayerBgColor(player: self.player))
                    .shadow(radius: 4)
            )
            
            CardItem(card: player.currentCard, width: 40, height: 67)
        }
    }
}

struct PlayerItem_Previews: PreviewProvider {
    static var previews: some View {
        PlayerItem(player: Player())
            .previewLayout(.fixed(width: 500, height: 200))
    }
}
