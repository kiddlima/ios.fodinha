//
//  TableGameView.swift
//  Fodinha
//
//  Created by Vinicius Lima on 06/05/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//
 
import SwiftUI

struct TableGameView: View {
    
    @ObservedObject var viewModel: TableGameViewModel
    
    init(gameId: String) {
        viewModel = TableGameViewModel(gameId: gameId)
    }

    var body: some View {
        
        ZStack {
            Color.customLightGray.edgesIgnoringSafeArea(.all)
            
            if viewModel.game != nil {
                ZStack{
                // Table
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 150, style: .circular)
                        .stroke(Color.white, lineWidth: 7)
                        .frame(width: geometry.size.width / 1.7, height: geometry.size.height / 1.6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 150, style: .circular)
                                .fill(Color.tableDefaultGreen)
                                .shadow(radius: 20)
                                .frame(width: geometry.size.width / 1.7, height: geometry.size.height / 1.6)
                    )
                }

                // Players
                GeometryReader { geometry in
                    ZStack{
                        VStack{
                            HStack {
                                if self.viewModel.hasPlayerInThatPosition(position: 1){
                                    PlayerItem(player : self.viewModel.getPlayerByPosition(position: 1)!, isTurn: self.viewModel.isPlayerTurnByPosition(position: 1))
                                } else {
                                    PlayerItem(player: Player(), isTurn: false).hidden()
                                }

                                if self.viewModel.hasPlayerInThatPosition(position: 0){
                                    PlayerItem(player : self.viewModel.getPlayerByPosition(position: 0)!, isTurn: self.viewModel.isPlayerTurnByPosition(position: 0))
                                } else {
                                    PlayerItem(player: Player(), isTurn: false).hidden()
                                }

                            }.offset(y: geometry.size.height / -4.5)

                            HStack {
                                if self.viewModel.hasPlayerInThatPosition(position: 4){
                                    PlayerItem(player : self.viewModel.getPlayerByPosition(position: 4)!, isTurn: self.viewModel.isPlayerTurnByPosition(position: 4))
                                } else {
                                    PlayerItem(player: Player(), isTurn: false).hidden()
                                }

                                if self.viewModel.hasPlayerInThatPosition(position: 5){
                                    PlayerItem(player : self.viewModel.getPlayerByPosition(position: 5)!, isTurn: self.viewModel.isPlayerTurnByPosition(position: 5))
                                } else {
                                    PlayerItem(player: Player(), isTurn: false).hidden()
                                }

                            }.offset(y: geometry.size.height / 4.5)
                        }.overlay(
                            HStack{
                                VStack (spacing: 20){
                                    if self.viewModel.hasPlayerInThatPosition(position: 2){
                                        PlayerItem(player : self.viewModel.getPlayerByPosition(position: 2)!, isTurn: self.viewModel.isPlayerTurnByPosition(position: 2))
                                    } else {
                                        PlayerItem(player: Player(), isTurn: false).hidden()
                                    }

                                    if self.viewModel.hasPlayerInThatPosition(position: 3){
                                        PlayerItem(player : self.viewModel.getPlayerByPosition(position: 3)!, isTurn: self.viewModel.isPlayerTurnByPosition(position: 3))
                                    } else {
                                        PlayerItem(player: Player(), isTurn: false).hidden()
                                    }

                                }.offset(x: geometry.size.height / -2.5)

                                VStack (spacing: 20){
                                    if self.viewModel.hasPlayerInThatPosition(position: 7){
                                        PlayerItem(player : self.viewModel.getPlayerByPosition(position: 7)!, isTurn: self.viewModel.isPlayerTurnByPosition(position: 7))
                                    } else {
                                        PlayerItem(player: Player(), isTurn: false).hidden()
                                    }

                                    if self.viewModel.hasPlayerInThatPosition(position: 5){
                                        PlayerItem(player : self.viewModel.getPlayerByPosition(position: 5)!, isTurn: self.viewModel.isPlayerTurnByPosition(position: 5))
                                    } else {
                                        PlayerItem(player: Player(), isTurn: false).hidden()
                                    }
                                }.offset(x: geometry.size.height / 2.5)
                        })
                    }
                }

                // Center Table
                VStack {
                    Text(viewModel.game!.hunchTime! ? "Rodade de palpítes" : "Rodada \(viewModel.game!.currentRound!)")
                        .font(.headline)
                        .foregroundColor(Color.white)

                    Text(viewModel.getTurnPlayerName())
                        .font(.body)
                        .foregroundColor(Color.customLighter2Gray)

                    }

                }.offset(x: -35, y: -15)

                VStack (alignment: .trailing) {
                    Spacer().frame(maxHeight: .infinity)
                    
                    if viewModel.shouldShowStartGameButton(){
                        HStack {
                            Button(action: {
                                self.viewModel.startGame(gameId: self.viewModel.game!.gameId!)
                            }) {
                                Text("Começar jogo")
                            }.buttonStyle(PrimaryButton())
                            
                            ActivityIndicator(shouldAnimate: self.$viewModel.loadingStartGame)
                        }
                    }
                    
                    if viewModel.isPlayersTurnToPlay(){
                        HStack {
                            Button(action: {
                                self.viewModel.playCard()
                            }) {
                                Text("Jogar carta")
                            }.buttonStyle(PrimaryButton())
                            
                            ActivityIndicator(shouldAnimate: self.$viewModel.loadingPlay)
                        }
                    }
                    
                    if viewModel.isPlayersTurnToHunch() {
                        HunchView(
                            cardAmount: self.viewModel.game!.cardAmount,
                            players: self.viewModel.game!.players,
                            viewModel: self.viewModel)
                            .padding(.trailing, 16)
                        
                    }

                    HStack (alignment: .bottom){
                        ScrollView (.horizontal) {
                            HStack (alignment: .lastTextBaseline) {
                                ForEach (viewModel.game!.players, id: \.playerId) { player in
                                    Text("\(player.name!) (\(player.points!) pontos)")
                                        .font(.caption)
                                        .foregroundColor(Color.customLighter2Gray)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 30)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 35)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                        .background(RoundedRectangle(cornerRadius: 4)
                            .fill(Color.customLighterGray)
                            .shadow(radius: 3))

                        if self.viewModel.currentPlayer != nil {
                            HStack {
                                ForEach(0 ..< (viewModel.currentPlayer?.cards.count)!, id: \.self) { index in
                                    Button(action: {
                                        self.viewModel.selectCard(position: index)
                                    }) {
                                        CardItem(card: self.viewModel.currentPlayer?.cards[index])
                                    }
                                }
                            }.padding(8)
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
                }.frame(maxHeight: .infinity)
            }
        }
        .onAppear {
            AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeLeft
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
        }
        .onDisappear {
            AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
        }
    }
}

struct TableGameView_Previews: PreviewProvider {
    static var previews: some View {
        TableGameView(gameId: "")
            .previewLayout(.fixed(width: 768, height: 320))
    }
}
