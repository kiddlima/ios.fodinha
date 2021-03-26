//
//  SelfPlayerView.swift
//  Truquero
//
//  Created by Vinicius Lima on 21/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import SwiftUI

struct SelfPlayerView: View {
    
    @Environment(\.presentationMode) var presentation
    
    @Binding var player: Player
    @State var game: Game
    @State var currentCards: [Card?]
    @Binding var showingHunch: Bool
    @ObservedObject var viewModel: TableGameViewModel
    
    var body: some View {
        VStack {
            HandCards(game: self.$viewModel.game,
                      currentPlayer: self.$viewModel.currentPlayer,
                      currentCards: self.$viewModel.currentPlayerCards,
                      viewModel: self.viewModel)

            ZStack (alignment: .topTrailing) {
                ZStack {
                    if !(self.player.status != nil) && self.player.status == 1 {
                        Text("\(self.player.points ?? 0) pts")
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
                    
                    if self.player.hunch != nil {
                        Text("\(getMiddleText())")
                            .foregroundColor((self.player.smallRoundWinner ?? false) ? .white : .dark3)
                            .font(Font.custom("Avenir-Regular", size: 14))
                        
                        if !self.getProps().3 {
                            Text("\(player.wins ?? 0) / \(player.hunch ?? 0)")
                                .font(Font.custom("Avenir-Medium", size: 18))
                                .bold()
                                .foregroundColor(self.getColorByPointStatus())
                        }
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
            .opacity(self.showingHunch ? 0 : 1)
            .offset(y: -5)
            .frame(minWidth: 215, maxWidth: 215, minHeight: 65, idealHeight: 65, maxHeight: 65,
                   alignment: .center)
            
        }
        .animation(.easeOut(duration: 0.3))
    }
    
    func getMiddleText() -> String {
        if self.player.smallRoundWinner ?? false {
            return "Venceu a rodada"
        } else if self.player.status == 0 {
            return "Eliminado"
        } else if self.player.status == 2 {
            return "Aguardando rodada"
        } else {
            return "Vitórias / Palpíte"
        }
    }
    
    //Return background, border & pointsBg, font color, win/hunch hidden
    func getProps() -> (Color, Color, Color, Bool) {
        if self.player.isTurn ?? false {
            return (.white, .darkWhite, .dark5, false)
        } else if self.player.smallRoundWinner ?? false {
            return (.winnerGreen, .darkGreen, .white, true)
        } else if self.player.status == 0 {
            return (.dark8, .dark8, .dark3, true)
        } else if self.player.status == 2 {
            return (Color.dark5.opacity(0.9), .dark5, .white, true)
        } else {
            return (Color.dark8, .dark5, .white, false)
        }
    }
    
    func getColorByPointStatus() -> Color {
        let pointsResult = (self.player.wins ?? 0) - (self.player.hunch ?? 0)
        
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
                       game: Game(),
                       currentCards: [Card](),
                       showingHunch: .constant(false),
                       viewModel: TableGameViewModel(gameId: ""))
    }
}
