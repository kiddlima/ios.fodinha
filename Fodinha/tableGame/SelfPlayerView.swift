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
    @Binding var isTurn: Bool
    @Binding var isWinner: Bool
    @Binding var isEliminated: Bool
    @Binding var isWaiting: Bool
    
    var body: some View {
        
        VStack {
            HandCards(cards: player.cards!)
            
            ZStack (alignment: .topTrailing) {
                ZStack {
                    if !self.isEliminated {
                        Text("1 pts")
                            .font(Font.custom("Avenir-Medium", size: 18))
                            .foregroundColor(getProps().2)
                            .padding(10)
                    }
                }
                .background(
                    RoundedCorners(tl: 0, tr: 12, bl: 12, br: 0).fill(getProps().1))
                
                VStack (alignment: .leading) {
                    Spacer()
                    
                    HStack {
                        Text("\(player.name!)")
                            .font(Font.custom("Avenir-Medium", size: 18))
                            .bold()
                            .foregroundColor(self.getProps().2)
                    }
                    
                    Text("\(getMiddleText())")
                        .foregroundColor(self.isWinner ? .white : .dark3)
                        .font(Font.custom("Avenir-Regular", size: 14))
                     
                    if !self.getProps().3 {
                        Text("\(player.wins!) / \(player.hunch!)")
                            .font(Font.custom("Avenir-Medium", size: 18))
                            .bold()
                            .foregroundColor(self.getColorByPointStatus())
                    }
                    
                    Spacer()
                }
                .frame(width: 215, height: 65, alignment: .leading)
                .padding(.top, 6)
                .padding(.bottom, 6)
                .padding(.trailing, 12)
                .padding(.leading, 12)
            }
            
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(self.getProps().0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(getProps().1, lineWidth: 3))
                )
            .animation(.default)
            .offset(y: -19)
            .frame(minWidth: 215, maxWidth: 215, minHeight: 65, idealHeight: 65, maxHeight: 65,
                   alignment: .center)
        }
    }
    
    func getMiddleText() -> String {
        if self.isWinner {
            return "Venceu a rodada"
        } else if self.isEliminated {
            return "Eliminado"
        } else if self.isWaiting {
            return "Aguardando rodada"
        } else {
            return "Vitórias / Palpíte"
        }
    }
    
    //Return background, border & pointsBg, font color, win/hunch hidden
    func getProps() -> (Color, Color, Color, Bool) {
        if self.isTurn {
            return (.white, .darkWhite, .dark5, false)
        } else if self.isWinner {
            return (.winnerGreen, .darkGreen, .white, true)
        } else if self.isEliminated {
            return (.dark8, .dark8, .dark3, true)
        } else if self.isWaiting {
            return (Color.dark5.opacity(0.9), .dark5, .white, true)
        } else {
            return (Color.dark7, .dark5, .white, false)
        }
    }
    
    func getColorByPointStatus() -> Color {
        let pointsResult = self.player.wins! - self.player.hunch!
        
        if pointsResult > 0 {
            return Color.red
        } else if pointsResult == 0 {
            return Color.green
        } else {
            return Color.yellow
        }
    }
}

struct SelfPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        SelfPlayerView(player: .constant(Player(mockedPlayer: true)),
                       isTurn: .constant(true),
                       isWinner: .constant(false),
                       isEliminated: .constant(false),
                       isWaiting: .constant(false))
    }
}
