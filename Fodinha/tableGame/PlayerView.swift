//
//  PlayerView.swift
//  Truquero
//
//  Created by Vinicius Lima on 23/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import SwiftUI

struct PlayerView: View {
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Binding var player: Player?
    @ObservedObject var viewModel: TableGameViewModel
   
    var body: some View {
        if player != nil {
            ZStack (alignment: .leading) {
                ZStack (alignment: .trailing) {
                    ZStack {
                        VStack (alignment: .leading) {
                            Spacer()
                            
                            Text("\(player!.name!)")
                                .font(Font.custom("Avenir-Medium", size: 14))
                                .bold()
                                .foregroundColor(self.getProps().1)
                            
                            if self.player?.hunch != nil {
                                if self.getProps().2 {
                                    Text("\(getMiddleText())")
                                        .foregroundColor(self.player!.smallRoundWinner! ? .white : .dark3)
                                        .font(Font.custom("Avenir-Regular", size: 12))
                                        .padding(.bottom, 6)
                                }
                                
                                if !self.getProps().2 {
                                    Text("\(player!.wins ?? 0) / \(player!.hunch ?? 0)")
                                        .font(Font.custom("Avenir-Medium", size: 14))
                                        .bold()
                                        .foregroundColor(self.getColorByPointStatus())
                                }
                            }
                            
                            Spacer()
                        }
                        .animation(.easeOut(duration: 0.3))
                        .frame(width: 120, height: 40, alignment: .leading)
                        .padding(.top, 6)
                        .padding(.bottom, 6)
                        .padding(.trailing, 8)
                        .padding(.leading, 12)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(self.getProps().0)
                    )
                    
                    Image("\(self.player?.currentCard?.imageName ?? "")")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 70)
                        .offset(x: 2)
                }
                
                if self.viewModel.timeRemainingToPlay != 0 && (self.player!.isTurn ?? false){
                    Capsule()
                        .fill(self.viewModel.timeRemainingToPlay > 5 ? Color.dark5 : Color.notificationRed)
                        .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .overlay(
                            Text("\(self.viewModel.timeRemainingToPlay)")
                                .foregroundColor(.white)
                                .font(Font.custom("Avenir-Medium", size: 15))
                                .onReceive(timer) { _ in
                                    if self.viewModel.timeRemainingToPlay > 0 {
                                        self.viewModel.timeRemainingToPlay -= 1
                                    }
                                }
                        )
                        .animation(.easeInOut(duration: 0.3))
                        .shadow(color: Color.black.opacity(0.5), radius: 6, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 2.0)
                        .offset(x: -22)
                }
            }
            .animation(.easeOut(duration: 0.3))
        }
        
    }
    
    func getMiddleText() -> String {
        if self.player?.smallRoundWinner ?? false {
            return "Venceu a rodada"
        } else if self.player?.status == 0 {
            return "Eliminado"
        } else if self.player?.status == 2 {
            return "Aguardando rodada"
        } else {
            return "Vitórias / Palpíte"
        }
    }
    
    //Return background, border & pointsBg, font color, win/hunch hidden
    func getProps() -> (Color, Color, Bool) {
        if self.player?.isTurn ?? false {
            return (.white, .dark5, false)
        } else if self.player?.smallRoundWinner ?? false {
            return (.winnerGreen, .white, true)
        } else if self.player?.status == 0 {
            return (.dark8, .dark3, true)
        } else if self.self.player?.status == 2 {
            return (Color.dark5.opacity(0.9), .white, true)
        } else {
            return (Color.dark5, .white, false)
        }
    }
    
    func getColorByPointStatus() -> Color {
        let pointsResult = (self.player!.wins ?? 0) - (self.player!.hunch ?? 0)
        
        if pointsResult > 0 {
            return Color.red
        } else if pointsResult == 0 {
            return Color.green
        } else {
            return Color.yellow
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(player: .constant(Player(mockedPlayer: true)), viewModel: TableGameViewModel(gameId: ""))
    }
}
