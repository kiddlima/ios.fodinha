//
//  HandCards.swift
//  Truquero
//
//  Created by Vinicius Lima on 22/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import SwiftUI

struct HandCards: View {
    
    @State var cards: [Card]
    
    @State var active = 0
    @State var destinations: [Int: CGRect] = [:]
    @State var card1OffSet = CGSize.zero
    @State var card2OffSet = CGSize.zero
    @State var card3OffSet = CGSize.zero
    @State var card4OffSet = CGSize.zero
    @State var card5OffSet = CGSize.zero
    
    @State var card1Angle = Double.zero
    @State var card2Angle = Double.zero
    @State var card3Angle = Double.zero
    @State var card4Angle = Double.zero
    @State var card5Angle = Double.zero
    
    @State var card1Padding = CGFloat.zero
    @State var card2Padding = CGFloat.zero
    @State var card3Padding = CGFloat.zero
    @State var card4Padding = CGFloat.zero
    @State var card5Padding = CGFloat.zero
    
    @State var selectedCard: Card?
    
    func getAngleAndPadding(position: Int) -> (Double, CGFloat) {
        switch cards.count {
        case 1:
            
            return (0, 0)
        case 2:
            if position == 0 {
                return (-5, 0)
            } else {
                return (5, 0)
            }
            
        case 3:
            if position == 0 {
                return (-5, -12)
            } else if position == 1 {
                return (0, 0)
            } else {
                return (5, -12)
            }
            
        case 4:
            if position == 0 {
                return (-20, -24)
            } else if position == 1 {
                return (-5, 0)
            } else if position == 2 {
                return (5, 0)
            } else {
                return (20, -24)
            }
            
        default:
            if position == 0 {
                return (-20, -24)
            } else if position == 1 {
                return (-5, -6)
            } else if position == 2 {
                return (0, 0)
            } else if position == 3 {
                return (5, -6)
            } else {
                return (20, -24)
            }
        }
    }
    
    func calculateLayout() {
        self.card1Angle = getAngleAndPadding(position: 0).0
        self.card1Padding = getAngleAndPadding(position: 0).1
        
        self.card2Angle = getAngleAndPadding(position: 1).0
        self.card2Padding = getAngleAndPadding(position: 1).1
        
        self.card3Angle = getAngleAndPadding(position: 2).0
        self.card3Padding = getAngleAndPadding(position: 2).1
        
        self.card4Angle = getAngleAndPadding(position: 3).0
        self.card4Padding = getAngleAndPadding(position: 3).1
        
        self.card5Angle = getAngleAndPadding(position: 4).0
        self.card5Padding = getAngleAndPadding(position: 4).1
    }
    
    var body: some View {
        
        VStack {
            DroppableAreaView(active: $active, id: 1, card: self.$selectedCard)
            
            HStack {
                if cards.count != 0 {
                    HandCardView()
                        .padding(.bottom, self.card1Padding)
                        .rotationEffect(.degrees(self.card1Angle))
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
                                            
                                            self.card1Angle = getAngleAndPadding(position: 0).0
                                        } else {
                                            self.selectedCard = cards[0]
                                            
                                            self.cards.remove(at: 0)
                                            
                                            calculateLayout()
                                        }
                                        
                                        self.active = 0
                                    }
                        )
                }
                
                if cards.count > 1 {
                    HandCardView()
                        .padding(.bottom, self.card2Padding)
                        .rotationEffect(.degrees(card2Angle))
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
                                            
                                            self.card2Angle = getAngleAndPadding(position: 1).0
                                        } else {
                                            self.selectedCard = cards[1]
                                            
                                            self.cards.remove(at: 1)
                                            
                                            calculateLayout()
                                        }
                                        
                                        self.active = 0
                                    }
                        )
                }
                
                if cards.count > 2 {
                    HandCardView()
                        .padding(.bottom, self.card3Padding)
                        .rotationEffect(.degrees(card3Angle))
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
                                            
                                            self.card3Angle = getAngleAndPadding(position: 2).0
                                        } else {
                                            self.selectedCard = cards[2]
                                            
                                            self.cards.remove(at: 2)
                                            
                                            calculateLayout()
                                        }
                                        
                                        self.active = 0
                                    }
                        )
                }
                
                if cards.count > 3 {
                    HandCardView()
                        .padding(.bottom, self.card4Padding)
                        .rotationEffect(.degrees(card4Angle))
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
                                            
                                            self.card4Angle = getAngleAndPadding(position: 3).0
                                        } else {
                                            self.selectedCard = cards[3]
                                            
                                            self.cards.remove(at: 3)
                                            
                                            calculateLayout()
                                        }
                                        
                                        self.active = 0
                                    }
                        )
                }
                
                if cards.count > 4 {
                    HandCardView()
                        .padding(.bottom, self.card5Padding)
                        .rotationEffect(.degrees(card5Angle))
                        .offset(x: self.card5OffSet.width, y: self.card5OffSet.height)
                        .gesture(DragGesture(minimumDistance: 0.1, coordinateSpace: .global)
                                    .onChanged { value in
                                        self.active = 0
                                        
                                        self.card5Angle = .zero
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
                                            
                                            self.card5Angle = getAngleAndPadding(position: 4).0
                                        } else {
                                            self.selectedCard = cards[4]
                                            
                                            self.cards.remove(at: 4)
                                            
                                            calculateLayout()
                                        }
                                        
                                        self.active = 0
                                    }
                        )
                }
                
            }.onAppear {
                calculateLayout()
            }
            .frame(height: 73)
            
        }.onPreferenceChange(DestinationDataKey.self) { preferences in
            for p in preferences {
                self.destinations[p.destination] = p.frame
            }
        }
    }
}
struct DroppableAreaView: View {
    @Binding var active: Int
    let id: Int
    @Binding var card: Card?
    
    var body: some View {
        Rectangle()
            .fill(self.active != id ? Color.black.opacity(0) : Color.black.opacity(0.5))
            .frame(width: 83, height: 120, alignment: .center)
            .offset(x: 0, y: 0)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .fill(self.card == nil ? Color.black.opacity(0.5) : Color.red)
                    .frame(width: 50, height: 75, alignment: .center)
            )
            .background(DestinationDataSetter(destination: id))
    }
}

struct HandCardView: View {
    
    //    var card: Card
    
    var body: some View{
        Image("paus1")
            .resizable()
            .scaledToFit()
            .padding(.leading, -10)
            .padding(.trailing, -10)
            .frame(height: 75)
            .animation(.easeOut(duration: 0.3))
            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0.0, y: 0.0)
        
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
        let card1 = Card(rank: 1, suit: "Paus", value: 2)
        let card2 = Card(rank: 1, suit: "Espada", value: 1)
        let card3 = Card(rank: 1, suit: "Ouro", value: 3)
        let card4 = Card(rank: 1, suit: "Paus", value: 2)
        let card5 = Card(rank: 1, suit: "Paus", value: 2)
        
        HandCards(cards: ([Card](arrayLiteral: card1, card2, card3, card4, card5)))
    }
}
