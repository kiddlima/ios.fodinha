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
                        .fill(Color.tableDefaultGreen)
                        .shadow(radius: 20)
                        .frame(width: geometry.size.width / 1.7, height: geometry.size.height / 1.6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 150, style: .circular)
                            .stroke(Color(red: 236/255, green: 234/255, blue: 235/255), lineWidth: 10)
                            .shadow(color: Color.black, radius: 25, x: 0, y: 0)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 150, style: .circular)
                   ))
                }

                // Players
                GeometryReader { geometry in
                    ZStack{
                        VStack{
                            HStack {
                                if self.viewModel.hasPlayerInThatPosition(position: 1){
                                    PlayerItem(player : self.viewModel.getPlayerByPosition(position: 1)!)
                                } else {
                                    PlayerItem(player: Player()).hidden()
                                }

                                if self.viewModel.hasPlayerInThatPosition(position: 0){
                                    PlayerItem(player : self.viewModel.getPlayerByPosition(position: 0)!)
                                } else {
                                    PlayerItem(player: Player()).hidden()
                                }

                            }.offset(y: geometry.size.height / -4.5)

                            HStack {
                                if self.viewModel.hasPlayerInThatPosition(position: 4){
                                    PlayerItem(player : self.viewModel.getPlayerByPosition(position: 4)!)
                                } else {
                                    PlayerItem(player: Player()).hidden()
                                }

                                if self.viewModel.hasPlayerInThatPosition(position: 5){
                                    PlayerItem(player : self.viewModel.getPlayerByPosition(position: 5)!)
                                } else {
                                    PlayerItem(player: Player()).hidden()
                                }

                            }.offset(y: geometry.size.height / 4.5)
                        }.overlay(
                            HStack{
                                VStack (spacing: 20){
                                    if self.viewModel.hasPlayerInThatPosition(position: 2){
                                        PlayerItem(player : self.viewModel.getPlayerByPosition(position: 2)!)
                                    } else {
                                        PlayerItem(player: Player()).hidden()
                                    }

                                    if self.viewModel.hasPlayerInThatPosition(position: 3){
                                        PlayerItem(player : self.viewModel.getPlayerByPosition(position: 3)!)
                                    } else {
                                        PlayerItem(player: Player()).hidden()
                                    }

                                }.offset(x: geometry.size.height / -2.5)

                                VStack (spacing: 20){
                                    if self.viewModel.hasPlayerInThatPosition(position: 7){
                                        PlayerItem(player : self.viewModel.getPlayerByPosition(position: 7)!)
                                    } else {
                                        PlayerItem(player: Player()).hidden()
                                    }

                                    if self.viewModel.hasPlayerInThatPosition(position: 5){
                                        PlayerItem(player : self.viewModel.getPlayerByPosition(position: 5)!)
                                    } else {
                                        PlayerItem(player: Player()).hidden()
                                    }
                                }.offset(x: geometry.size.height / 2.5)
                        })
                    }
                }

                // Center Table
                VStack {
                    if viewModel.smallRoundWinner == nil {
                        Text(viewModel.game!.message!)
                            .font(.headline)
                            .foregroundColor(Color.white)

                        Text(viewModel.game!.hunchTime! ? "Rodade de palpítes" : "Rodada \(viewModel.game!.currentRound!)")
                            .font(.body)
                            .foregroundColor(Color.customLighter2Gray)

                    } else {
                       GeometryReader { geometry in
                           RoundedRectangle(cornerRadius: 150, style: .circular)
                            .fill(Color.darkGreen)
                            .frame(width: geometry.size.width / 3.2, height: geometry.size.height / 3.6)
                            .overlay(
                                HStack {
                                    Text("\(self.viewModel.smallRoundWinner!.shortName!) venceu a rodada com")
                                        .font(.subheadline)
                                        .foregroundColor(Color.white)
                                    
                                    CardItem(
                                        card: self.viewModel.smallRoundWinner?.currentCard,
                                        width: 40,
                                        height: 67)
                                }.padding(24)
                           )
                        }
                    }
                }

                }.offset(x: -35, y: -15)

                VStack (alignment: .trailing) {
                    
                    Spacer().frame(maxHeight: .infinity)
                    
                    // Start game button
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
                    
                    // Play card button
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
                    
                    // Hunch view
                    if viewModel.isPlayersTurnToHunch() {
                        HunchView(
                            cardAmount: self.viewModel.game!.cardAmount,
                            players: self.viewModel.game!.players,
                            viewModel: self.viewModel)
                    }
                    
                    Spacer()

                    // Footer with cards and points
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
                                        CardItem(card: self.viewModel.currentPlayer?.cards[index],
                                                 width: 55, height: 91)
                                            .animation(.easeOut)
                                            .offset(y: (self.viewModel.currentPlayer?.cards[index] != nil && self.viewModel.currentPlayer?.cards[index]!.selected == true) ? -10 : 0)
                                    }
                                }
                            }
                        }
                    }.edgesIgnoringSafeArea(.leading)
                    
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
