//
//  SelfPlayerView.swift
//  Truquero
//
//  Created by Vinicius Lima on 21/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import SwiftUI

struct SelfPlayerView: View {
    
    @Binding var player: Player
    
    var body: some View {
        
        ZStack (alignment: .topTrailing) {
            ZStack {
                Text("1 pts")
                    .padding(8)
            }
            .background(
                RoundedCorners(tl: 6, tr: 6, bl: 0, br: 0).fill(Color.dark7))
            
            VStack (alignment: .leading) {
                HStack {
                    Text("\(player.name)")
                        .font(Font.custom("Avenir-Medium", size: 18))
                        .bold()
                        .foregroundColor(.white)
                }
                
                Text("Vitórias / Palpíte")
                    .foregroundColor(.dark3)
                    .font(Font.custom("Avenir-Regular", size: 14))
                    
                Text("\(player.wins) / \(player.hunch)")
                    .font(Font.custom("Avenir-Medium", size: 18))
                    .bold()
                    .foregroundColor(self.getColorByPointStatus())
            }
            .frame(width: 215, alignment: .leading)
            .padding()
        }
        .frame(width: 250, alignment: .topTrailing)
        .background(Color.dark5)
        .border(Color.dark3, width: 3)
        .cornerRadius(10)
    }
    
    func getColorByPointStatus() -> Color {
        let pointsResult = self.player.wins - self.player.hunch
        
        if pointsResult > 0 {
            return Color.red
        } else if pointsResult == 0 {
            return Color.green
        } else {
            return Color.yellowLight
        }
    }
}

struct SelfPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        SelfPlayerView(player: .constant(Player(name: "Jimmy", hunch: 1, wins: 2)))
    }
}
