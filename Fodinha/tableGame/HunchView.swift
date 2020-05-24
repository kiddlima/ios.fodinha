//
//  HunchView.swift
//  Fodinha
//
//  Created by Vinicius Lima on 14/05/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import SwiftUI

struct HunchView: View {
    
    var cardAmount: Int?
    var players: [Player]?
    var viewModel: TableGameViewModel?
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Quantas você faz?")
                .font(.headline)
                .foregroundColor(Color("customDarkGray"))
            
            HStack {
                ForEach (-1 ..< cardAmount!, id: \.self) { choice in
                    Button(action: {
                        self.viewModel?.setPlayerHunch(hunch: choice + 1)
                    }) {
                        Text("\(choice + 1)")
                    }
                    .buttonStyle(PrimaryButton())
                    .padding(8)
                }
            }

            VStack (alignment: .leading) {
                ForEach (players!, id: \.playerId) { player in
                    PlayerHunchView(player: player)
                }
            }
        }
        .transition(.slide)
        .cornerRadius(8)
        .padding(16)
        .background(
               RoundedRectangle(cornerRadius: 4)
               .fill(Color.white)
               .shadow(radius: 4)
           )
        
    }
   
}

struct HunchView_Previews: PreviewProvider {
    static var previews: some View {
        HunchView(cardAmount: 5)
    }
}
