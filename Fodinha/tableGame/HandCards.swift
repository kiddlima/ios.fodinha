//
//  HandCards.swift
//  Truquero
//
//  Created by Vinicius Lima on 22/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import SwiftUI

struct HandCards: View {
    
    @Binding var game: Game
    @Binding var currentPlayer: Player
    @Binding var currentCards: [Card?]
    @ObservedObject var viewModel: TableGameViewModel
    
    @State var active = 0
    @State var destinations: [Int: CGRect] = [:]
    @State var card1OffSet = CGSize.zero
    @State var card2OffSet = CGSize.zero
    @State var card3OffSet = CGSize.zero
    @State var card4OffSet = CGSize.zero
    @State var card5OffSet = CGSize.zero
    
    @State var selectedCard: Card?
    
    var body: some View {
        VStack {
            ZStack {
                if !(self.game.hunchTime ?? true) && self.currentPlayer.id == self.game.turn{
                    DroppableAreaView(active: $active, id: 1, card: self.$selectedCard, viewModel: self.viewModel)
                } else {
                    DroppableAreaView(active: $active, id: 1, card: self.$selectedCard, viewModel: self.viewModel).hidden()
                }
                
            }.overlay(
                Image("\(self.viewModel.currentPlayer.currentCard?.imageName ?? "")")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 75)
                    .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0.0, y: 0.0)
                    .isHidden(self.viewModel.currentPlayer.currentCard == nil || ((self.viewModel.game.cardAmount ?? 1 == 1) && self.viewModel.game.hunchTime ?? false))
            )
            
            HStack {
                if self.viewModel.currentPlayerCards.count == 0
                    && (self.viewModel.game.cardAmount ?? 0) == 1
                    && (self.viewModel.game.active ?? false)
                    && self.viewModel.currentPlayer.currentCard != nil
                    && (self.viewModel.game.hunchTime ?? false){
                    Image("verso")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 75)
                        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0.0, y: 0.0)
                }
                
                if self.viewModel.currentPlayerCards.compactMap({$0}).count == 0
                    && ((self.viewModel.game.cardAmount ?? 0 != 1) || !(self.viewModel.game.hunchTime ?? false)) {
                    Image("paus1")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 75)
                        .hidden()
                }
              
                if let count = self.viewModel.currentPlayerCards.compactMap({$0}).count {
                    if self.viewModel.currentPlayerCards.count > 0 {
                        if let card = self.viewModel.currentPlayerCards[0] {
                            Image("\(card.imageName ?? "")")
                                .resizable()
                                .scaledToFit()
                                .padding(.leading, -10)
                                .padding(.trailing, -10)
                                .frame(height: 75)
                                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0.0, y: 0.0)
                                .padding(.bottom,
                                         (count <= 2 || self.card1OffSet != .zero) ? 0 : (count == 3 ? -12 : -24))
                                
                                
                                .rotationEffect(
                                    .degrees((count == 1 || self.card1OffSet != .zero) ? 0 : (count > 3 ? -20 : -5)))
                                
                                
                                .offset(x: self.card1OffSet.width, y: self.card1OffSet.height)
                                .gesture(DragGesture(minimumDistance: 0.1, coordinateSpace: .global)
                                            .onChanged { value in
                                                self.active = 0
                                                
                                                self.card1OffSet = value.translation
                                                
                                                for (id, frame) in self.destinations {
                                                    if frame.contains(value.location) {
                                                        self.active = id
                                                        
                                                    }
                                                }
                                            }
                                            .onEnded { value in
                                                if self.active != 1 {
                                                    self.card1OffSet = .zero
                                                } else {
                                                    if !(self.viewModel.game.hunchTime ?? true) && (self.viewModel.game.turn == self.viewModel.currentPlayer.id) {
                                                        self.selectedCard = self.viewModel.currentPlayerCards[0]
                                                        
                                                        self.viewModel.currentPlayerCards[0] = nil
                                                        
                                                        self.viewModel.playCard(card: self.selectedCard!)
                                                    }
                                                    
                                                    self.card1OffSet = .zero
                                                }
                                                
                                                self.active = 0
                                            }
                                )
                        }
                    }
                }
                
                if let count = self.viewModel.currentPlayerCards.compactMap({$0}).count {
                    if self.viewModel.currentPlayerCards.count > 1 {
                        if let card = self.viewModel.currentPlayerCards[1] {
                            Image("\(card.imageName ?? "")")
                                .resizable()
                                .scaledToFit()
                                .padding(.leading, -10)
                                .padding(.trailing, -10)
                                .frame(height: 75)
                                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0.0, y: 0.0)
                                .padding(.bottom,
                                         (count < 5 || card2OffSet != .zero) ? 0 : -6)
                                
                                
                                .rotationEffect(
                                    .degrees((count == 3 || card2OffSet != .zero) ? 0 : (count == 2 ? 5 : -5)))
                                
                                .offset(x: self.card2OffSet.width, y: self.card2OffSet.height)
                                .gesture(DragGesture(minimumDistance: 0.1, coordinateSpace: .global)
                                            .onChanged { value in
                                                self.active = 0
                                                
                                                self.card2OffSet = value.translation
                                                
                                                for (id, frame) in self.destinations {
                                                    if frame.contains(value.location) {
                                                        self.active = id
                                                    }
                                                }
                                            }
                                            .onEnded { value in
                                                if self.active != 1 {
                                                    self.card2OffSet = .zero
                                                } else {
                                                    if !(self.viewModel.game.hunchTime ?? true) && (self.viewModel.game.turn == self.viewModel.currentPlayer.id) {
                                                        self.selectedCard = self.viewModel.currentPlayerCards[1]
                                                        
                                                        self.viewModel.currentPlayerCards[1] = nil
                                                        
                                                        self.viewModel.playCard(card: self.selectedCard!)
                                                        
                                                    }
                                                    
                                                    self.card2OffSet = .zero
                                                }
                                                
                                                self.active = 0
                                            }
                                )
                        }
                    }
                }
                
                if let count = self.viewModel.currentPlayerCards.compactMap({$0}).count {
                    if self.viewModel.currentPlayerCards.count > 2 {
                        if let card = self.viewModel.currentPlayerCards[2] {
                            Image("\(card.imageName ?? "")")
                                .resizable()
                                .scaledToFit()
                                .padding(.leading, -10)
                                .padding(.trailing, -10)
                                .frame(height: 75)
                                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0.0, y: 0.0)
                                .padding(.bottom,
                                         (count >= 4 || self.card3OffSet != .zero) ? 0 : -12)
                                
                                
                                .rotationEffect(
                                    .degrees((count == 5 || self.card3OffSet != .zero) ? 0 : 5))
                                
                                
                                .offset(x: self.card3OffSet.width, y: self.card3OffSet.height)
                                .gesture(DragGesture(minimumDistance: 0.1, coordinateSpace: .global)
                                            .onChanged { value in
                                                self.active = 0
                                                
                                                self.card3OffSet = value.translation
                                                
                                                for (id, frame) in self.destinations {
                                                    if frame.contains(value.location) {
                                                        self.active = id
                                                    }
                                                }
                                            }
                                            .onEnded { value in
                                                if self.active != 1 {
                                                    self.card3OffSet = .zero
                                                } else {
                                                    if !(self.viewModel.game.hunchTime ?? true) && (self.viewModel.game.turn == self.viewModel.currentPlayer.id){
                                                        
                                                        self.selectedCard = self.viewModel.currentPlayerCards[2]
                                                        
                                                        self.viewModel.currentPlayerCards[2] = nil
                                                        
                                                        self.viewModel.playCard(card: self.selectedCard!)
                                                        
                                                    }
                                                    
                                                    self.card3OffSet = .zero
                                                }
                                                
                                                self.active = 0
                                            }
                                )
                        }
                    }
                }
                
                if let count = self.viewModel.currentPlayerCards.compactMap({$0}).count {
                    if self.viewModel.currentPlayerCards.count > 3 {
                        if let card = self.viewModel.currentPlayerCards[3] {
                            Image("\(card.imageName ?? "")")
                                .resizable()
                                .scaledToFit()
                                .padding(.leading, -10)
                                .padding(.trailing, -10)
                                .frame(height: 75)
                                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0.0, y: 0.0)
                                .padding(.bottom,
                                         (card4OffSet != .zero ? 0 : (count == 4 ? -24 : -6)))
                                
                                
                                .rotationEffect(
                                    .degrees(card4OffSet != .zero ? 0 : (count == 4 ? 20 : 5)))
                                
                                .offset(x: self.card4OffSet.width, y: self.card4OffSet.height)
                                .gesture(DragGesture(minimumDistance: 0.1, coordinateSpace: .global)
                                            .onChanged { value in
                                                self.active = 0
                                                
                                                self.card4OffSet = value.translation
                                                
                                                for (id, frame) in self.destinations {
                                                    if frame.contains(value.location) {
                                                        self.active = id
                                                    }
                                                }
                                            }
                                            .onEnded { value in
                                                if self.active != 1 {
                                                    self.card4OffSet = .zero
                                                } else {
                                                    if !(self.viewModel.game.hunchTime ?? true) && (self.viewModel.game.turn == self.viewModel.currentPlayer.id) {
                                                        self.selectedCard = self.viewModel.currentPlayerCards[3]
                                                        
                                                        self.viewModel.currentPlayerCards[3] = nil
                                                        
                                                        self.viewModel.playCard(card: self.selectedCard!)
                                                    }
                                                    
                                                    self.card4OffSet = .zero
                                                }
                                                
                                                self.active = 0
                                            }
                                )
                        }
                    }
                }
                
                if self.viewModel.currentPlayerCards.count > 4 {
                    if let card = self.viewModel.currentPlayerCards[4] {
                        Image("\(card.imageName ?? "")")
                            .resizable()
                            .scaledToFit()
                            .padding(.leading, -10)
                            .padding(.trailing, -10)
                            .frame(height: 75)
                            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0.0, y: 0.0)
                            .padding(.bottom,
                                     card5OffSet != .zero ? 0 : -24)
                            
                            
                            .rotationEffect(
                                .degrees(card5OffSet != .zero ? 0 : 20))
                            
                            .offset(x: self.card5OffSet.width, y: self.card5OffSet.height)
                            .gesture(DragGesture(minimumDistance: 0.1, coordinateSpace: .global)
                                        .onChanged { value in
                                            self.active = 0
                                            self.card5OffSet = value.translation
                                            
                                            for (id, frame) in self.destinations {
                                                if frame.contains(value.location) {
                                                    self.active = id
                                                }
                                            }
                                        }
                                        .onEnded { value in
                                            if self.active != 1 {
                                                self.card5OffSet = .zero
                                            } else {
                                                if !(self.viewModel.game.hunchTime ?? true) && (self.viewModel.game.turn == self.viewModel.currentPlayer.id) {
                                                    self.selectedCard = self.viewModel.currentPlayerCards[4]
                                                    
                                                    self.viewModel.currentPlayerCards[4] = nil
                                                    
                                                    self.viewModel.playCard(card: self.selectedCard!)
                                                }
                                                
                                                self.card5OffSet = .zero
                                            }
                                            
                                            self.active = 0
                                        }
                            )
                    }
                }
                
                
            }
            .frame(height: 73)
            
        }.onPreferenceChange(DestinationDataKey.self) { preferences in
            for p in preferences {
                self.destinations[p.destination] = p.frame
            }
        }.animation(.easeIn(duration: 0.3))
    }
}

struct DroppableAreaView: View {
    @Binding var active: Int
    let id: Int
    @Binding var card: Card?
    @ObservedObject var viewModel: TableGameViewModel
    
    var body: some View {
        Rectangle()
            .fill(self.active != id ? Color.black.opacity(0.4) : Color.black.opacity(0.8))
            .frame(width: 50, height: 75)
            .scaledToFit()
            .offset(x: 0, y: 0)
            .cornerRadius(4)
            .background(DestinationDataSetter(destination: id))
    }
}

struct DestinationDataKey: PreferenceKey {
    typealias Value = [DestinationData]
    
    static var defaultValue: [DestinationData] = []
    
    static func reduce(value: inout [DestinationData], nextValue: () -> [DestinationData]) {
        value.append(contentsOf: nextValue())
    }
}

struct DestinationData: Equatable {
    let destination: Int
    let frame: CGRect
}

struct DestinationDataSetter: View {
    let destination: Int
    
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .preference(key: DestinationDataKey.self,
                            value: [DestinationData(destination: self.destination, frame: geometry.frame(in: .global))])
        }
    }
}


struct HandCards_Previews: PreviewProvider {
    static var previews: some View {
        HandCards(game: .constant(Game()),
                  currentPlayer: .constant(Player()),
                  currentCards: .constant([Card]()),
                  viewModel: TableGameViewModel(gameId: ""))
    }
}
