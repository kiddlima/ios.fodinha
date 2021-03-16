//
//  HunchView.swift
//  Fodinha
//
//  Created by Vinicius Lima on 14/05/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import SwiftUI

struct HunchView: View {
    
    var choices: [Choice]?
    var players: [Player]?
    var viewModel: TableGameViewModel
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Quantas você faz?")
                .font(.subheadline)
                .foregroundColor(Color.white)
            
            Spacer()
            
//            HStack (spacing: 0) {
//                ForEach(0 ..< self.choices!.count) { index in
//                    Button(action: {
//                        self.viewModel.setChoice(selectedChoice: self.choices![index])
//                    }) {
//                        Text("\(self.choices![index].number)")
//                    }
//                    .padding(2)
//                    .disabled(!self.choices![index].available!)
//                    .buttonStyle(SelectedButton(selected: self.choices![index].selected, disabled: !self.choices![index].available!))
//                }
//            }
            
            Spacer()
            
//            VStack (alignment: .leading) {
//                ForEach (players!, id: \.playerId) { player in
//                    PlayerHunchView(player: player)
//                }
//            }
            
            Spacer()
            
            Button(action: {
                self.viewModel.setPlayerHunch()
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
        HunchView(choices: [], players: [], viewModel: TableGameViewModel(gameId: ""))
    }
}
