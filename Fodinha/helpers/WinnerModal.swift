//
//  WinnerModal.swift
//  Truquero
//
//  Created by Vinicius Lima on 28/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import SwiftUI
import Lottie
import FirebaseAuth

struct WinnerModal: View {
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var winner: Player
    @Binding var currentPlayer: Player
    @Binding var players: [Player]?
    @Binding var loadingLeave: Bool
    @Binding var loadingRematch: Bool
    @ObservedObject var viewModel: TableGameViewModel
    var onLeave: () -> Void
    var onPlayAgain: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                LottieView(name: "crown", loop: true, play: .constant(1))
                    .frame(width: 72, height: 72)
                Text("\(winner.name!) venceu o jogo!")
                    .font(Font.custom("Avenir-Medium", size: 24))
                    .bold()
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(4)
            .background(Color.dark6)
            
            ScrollView {
                VStack (alignment: .leading) {
                    ForEach(0 ..< self.players!.count) { index in
                        let player = self.players![index]
                        
                        HStack {
                            LottieView(name: "checkmark", loop: false, play: .constant(1))
                                .frame(width: 24, height: 24)
                                .isHidden(!(player.confirmed ?? false))
                            
                            Text("\(index + 1) - \(player.name!) (\(player.points!) \(player.points! == 1 ? "pt" : "pts"))")
                                .font(Font.custom("Avenir-Medium", size: 18))
                                .foregroundColor(index == 0 ? .winnerGreen : .dark3)
                        }
                        .padding(.top, -4)
                    }
                }
                .padding(.leading, 160)
                .padding(.top, 16)
                .frame(width: 600, alignment: .leading)
                .background(Color.dark8)
            }
            .frame(width: 600, alignment: .center)
            
            Rectangle()
                .fill(Color.dark5)
                .frame(width: 600, height: 3)
            
            HStack {
                Capsule()
                    .fill(Color.dark5)
                    .frame(width: 50, height: 50, alignment: .center)
                    .overlay(
                        Text("\(self.viewModel.timeRemainingToPlay)")
                            .foregroundColor(.white)
                            .font(Font.custom("Avenir-Medium", size: 16))
                            .onReceive(timer) { _ in
                                if self.viewModel.timeRemainingToPlay > 0 {
                                    self.viewModel.timeRemainingToPlay -= 1
                                }
                            }
                    )
                    .animation(.easeInOut(duration: 0.3))
                    .shadow(color: Color.black.opacity(0.2), radius: 6, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 2.0)
                
                HStack {
                    Button(action: {
                        self.onLeave()
                    }, label: {
                        if self.loadingLeave {
                            ActivityIndicator(shouldAnimate: $loadingLeave)
                        } else {
                            Text("Sair")
                        }
                    })
                    .buttonStyle(SecondaryButtonStyle())
                    
                    if !(self.currentPlayer.confirmed ?? false) {
                        Button(action: {
                            self.onPlayAgain()
                        }, label: {
                            if self.loadingRematch {
                                ActivityIndicator(shouldAnimate: $loadingRematch)
                            } else {
                                Text("Jogar novamente")
                            }
                        })
                        .buttonStyle(GoldenButtonStyle())
                    } else {
                        Button(action: {
                            self.onPlayAgain()
                        }, label: {
                            if self.loadingRematch {
                                ActivityIndicator(shouldAnimate: $loadingRematch)
                            } else {
                                Text("Pronto")
                            }
                        })
                        .buttonStyle(GreenButtonStyle())
                    }
                    
                }
                .frame(width: 500, alignment: .trailing)
            }
            .padding(.top, 8)
            .padding(.bottom, 16)
            .frame(width: 600)
            .background(Color.dark8)
        }
        .frame(minWidth: 600, maxWidth: 600, minHeight: 80, maxHeight: 300, alignment: .center)
        .background(Color.dark8)
        .cornerRadius(20)
    }
}

struct WinnerModal_Previews: PreviewProvider {
    static var previews: some View {
        let player = Player(mockedPlayer: true)
        let player2 = Player(mockedPlayer: true)
        
        WinnerModal(winner: Player(mockedPlayer: true),
                    currentPlayer: .constant(Player()),
                    players: .constant([Player](arrayLiteral: player, player2)),
                    loadingLeave: .constant(false),
                    loadingRematch: .constant(false),
                    viewModel: TableGameViewModel(gameId: ""),
                    onLeave: {
            
                    }, onPlayAgain: {
            
                    })
            .previewLayout(.fixed(width: 1068, height: 420))
    }
}
