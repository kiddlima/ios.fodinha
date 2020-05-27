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
                .font(.subheadline)
                .foregroundColor(Color.white)
            
            Spacer()
            
            HStack (spacing: 0) {
                ForEach (-1 ..< cardAmount!, id: \.self) { choice in
                    Button(action: {
                        self.viewModel?.userHunchChoice = choice + 1
                    }) {
                        Text("\(choice + 1)")
                    }
                    .padding(2)
                    .buttonStyle(PrimaryButton())
                    .background(
                        (self.viewModel?.userHunchChoice != nil &&
                        (self.viewModel?.userHunchChoice! == choice + 1))
                            ? Color.customLightGray
                            : nil)
                }
            }
            
            Spacer()

            VStack (alignment: .leading) {
                ForEach (players!, id: \.playerId) { player in
                    PlayerHunchView(player: player)
                }
            }
            
            Spacer()
            
            Button(action: {
                self.viewModel?.setPlayerHunch(hunch: (self.viewModel?.userHunchChoice)!)
            }) {
                Text("Confirmar")
            }
            .padding(2)
            .buttonStyle(PrimaryButton())
            
            
            
        }
        .transition(.slide)
        .cornerRadius(8)
        .padding(16)
        .background(
               RoundedRectangle(cornerRadius: 4)
                .fill(Color.customDarkGray)
               .shadow(radius: 4)
           )
        
    }
   
}

struct HunchView_Previews: PreviewProvider {
    static var previews: some View {
        HunchView(cardAmount: 5)
    }
}
