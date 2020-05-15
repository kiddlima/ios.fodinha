//
//  PlayerHunchView.swift
//  Fodinha
//
//  Created by Vinicius Lima on 14/05/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import SwiftUI

struct PlayerHunchView: View {
    
    var player: Player
    
    var body: some View {
        VStack {
            if player.hunch != nil {
                Text("Faz \(self.player.hunch!) - \(self.player.name)")
                    .font(.caption)
                    .foregroundColor(Color("customLightGray"))
                    .padding(.top, 4)
            }
        }
    }
}

struct PlayerHunchView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerHunchView(player: Player())
    }
}
