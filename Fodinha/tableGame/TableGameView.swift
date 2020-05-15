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
    
    var body: some View {
        
        ZStack (alignment: .bottomTrailing){
            Color.customDarkGray.edgesIgnoringSafeArea(.all)
            
            ZStack{
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 150, style: .circular)
                        .stroke(Color.white, lineWidth: 2)
                        .frame(width: geometry.size.width / 1.7, height: geometry.size.height / 1.6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 150, style: .circular)
                                .fill(Color.tableDefaultRedColor)
                                .shadow(radius: 20)
                                .frame(width: geometry.size.width / 1.7, height: geometry.size.height / 1.6)
                    )
                }

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

                VStack {
                    Text("Rodada \(viewModel.game.currentRound!)")
                        .font(.headline)
                        .foregroundColor(Color.white)

                    Text(viewModel.getTurnPlayerName())
                        .font(.body)
                        .foregroundColor(Color.gray)

                }

            }.offset(x: -35, y: -15)

            VStack (alignment: .trailing) {
                if viewModel.shouldShowStartGameButton(){
                    Button(action: {
                        self.viewModel.startGame(gameId: self.viewModel.game.gameId!)
                    }) {
                        Text("Começar jogo")
                    }
                }
                
                if viewModel.isPlayersTurnToHunch() {
                    HunchView(
                        cardAmount: self.viewModel.game.cardAmount,
                        players: self.viewModel.game.players,
                        viewModel: self.viewModel)
                }

                HStack (alignment: .bottom){
                    ScrollView (.horizontal) {
                        HStack (alignment: .lastTextBaseline) {
                            ForEach (viewModel.game.players, id: \.playerId) { player in
                                Text("\(player.name) (\(player.points!) pontos)")
                                    .font(.caption)
                                    .foregroundColor(Color.gray)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 30)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .background(RoundedRectangle(cornerRadius: 4)
                    .fill(/*@START_MENU_TOKEN@*/Color("customLightGray")/*@END_MENU_TOKEN@*/)
                    .shadow(radius: 4))

                    HStack {
                        ForEach(0 ..< viewModel.game.players[0].cards.count, id: \.self) { index in
                            CardItem(card: self.viewModel.game.players[0].cards[index])
                        }
                    }.padding(8)
                }
            }
        }
    }
}

struct TableGameView_Previews: PreviewProvider {
    static var previews: some View {
        TableGameView(viewModel: TableGameViewModel(game: Game()))
            .previewLayout(.fixed(width: 768, height: 320))
    }
}
