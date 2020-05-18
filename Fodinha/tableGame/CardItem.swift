//
//  CardItem.swift
//  Fodinha
//
//  Created by Vinicius Lima on 08/05/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import SwiftUI

struct CardItem: View {
    
    var card: Card?
    
    var body: some View {
        VStack{
            if card != nil {
                Image((card?.imageName)!)
                .resizable()
                .cornerRadius(4)
                .frame(width: 40, height: 67)
                
            } else {
                Image("verso")
                .resizable()
                .cornerRadius(4)
                .frame(width: 40, height: 67)
            }
        }
        .frame(width: 40, height: 67)
        .background(
            RoundedRectangle(cornerRadius: 4)
            .fill(Color.white)
            .shadow(radius: 4)
        )
    }
}

struct CardItem_Previews: PreviewProvider {
    static var previews: some View {
        CardItem(card: Card(rank: 4, suit: "paus", value: 4))
    }
}
