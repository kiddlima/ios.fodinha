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
    var groupedPlayers = [Int: [Player]]()
    
    init(players: Binding<[Player]?>) {
        self._players = players
        
        self.players?.forEach({ player in
            if let points = player.points {
                if groupedPlayers[points] == nil {
                  groupedPlayers[points] = [Player]()
                }
                
                groupedPlayers[points]?.append(player)
            }
        })
        
        self.groupedPlayers.forEach { key, players in
            if players.isEmpty {
                self.groupedPlayers.removeValue(forKey: key)
            }
        }
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            ForEach(Array(groupedPlayers.keys).sorted(by: { $0 > $1 }), id: \.self) { key in
                if let players = self.groupedPlayers[key] {
                    GroupedStandingView(samePointPlayers: players)
                }
            }
        }
        .animation(.none)
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
                    .strikethrough(player.status == 0)
                    .foregroundColor(player.status == 0 ? Color.dark5 : Color.dark3)
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
        let player5 = Player(mockedPlayer: true, points: 2)
        let player6 = Player(mockedPlayer: true, points: 2)
        let player7 = Player(mockedPlayer: true, points: 3)
        
        StandingsView(players: .constant([Player](arrayLiteral:
            player1, player2, player3, player4, player5, player6, player7
        )))
    }
}
