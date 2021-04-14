//
//  StandingsView.swift
//  Truquero
//
//  Created by Vinicius Lima on 21/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import SwiftUI

struct StandingsView: View {
    
    @Binding var players: [Player]?
    
    var zeroPointPlayers: [Player]?
    var onePointPlayers: [Player]?
    var twoPointPlayers: [Player]?
    var threePointPlayers: [Player]?
    var fourPointPlayers: [Player]?
    var fiveOrMorePointPlayers: [Player]?
    
    init(players: Binding<[Player]?>) {
        self._players = players
        
        self.zeroPointPlayers = getPlayersByPoint(point: 0)
        self.onePointPlayers = getPlayersByPoint(point: 1)
        self.twoPointPlayers = getPlayersByPoint(point: 2)
        self.threePointPlayers = getPlayersByPoint(point: 3)
        self.fourPointPlayers = getPlayersByPoint(point: 4)
        self.fiveOrMorePointPlayers = getPlayersByPoint(point: 5)
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            if !fiveOrMorePointPlayers!.isEmpty {
                GroupedStandingView(samePointPlayers: fiveOrMorePointPlayers!)
            }
            
            if !fourPointPlayers!.isEmpty {
                GroupedStandingView(samePointPlayers: fourPointPlayers!)
            }
            
            if !threePointPlayers!.isEmpty {
                GroupedStandingView(samePointPlayers: threePointPlayers!)
            }
            
            if !twoPointPlayers!.isEmpty {
                GroupedStandingView(samePointPlayers: twoPointPlayers!)
            }
            
            if !onePointPlayers!.isEmpty {
                GroupedStandingView(samePointPlayers: onePointPlayers!)
            }
            
            if !zeroPointPlayers!.isEmpty {
                GroupedStandingView(samePointPlayers: zeroPointPlayers!)
            }
        }
    }
    
    func getPlayersByPoint(point: Int) -> [Player] {
        var groupedPlayers = [Player]()
        
        self.players!.forEach { player in
            if player.points == point {
                groupedPlayers.append(player)
            }
        }
        
        return groupedPlayers
    }
}

struct GroupedStandingView: View {
    
    var samePointPlayers: [Player]
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("\(samePointPlayers[0].points!) pontos")
                .foregroundColor(.white)
                .bold()
                .font(Font.custom("Avenir-Medium", size: 18))
                .padding(.bottom, 3)
            
            ForEach(self.samePointPlayers, id: \.id) { player in
                Text("\(player.name!)")
                    .font(Font.custom("Avenir-Medium", size: 16))
                    .strikethrough(self.samePointPlayers[0].points == 5)
                    .foregroundColor(self.samePointPlayers[0].points == 5 ? Color.dark5 : Color.dark3)
            }
        }
        .padding(.top, 4)
        
    }
}

struct StandingsView_Previews: PreviewProvider {
    static var previews: some View {
        let player1 = Player(mockedPlayer: true)
        let player2 = Player(mockedPlayer: true)
        let player3 = Player(mockedPlayer: true)
        let player4 = Player(mockedPlayer: true, points: 2)
        
        StandingsView(players: .constant([Player](arrayLiteral:
            player1, player2, player3, player4
        )))
    }
}
