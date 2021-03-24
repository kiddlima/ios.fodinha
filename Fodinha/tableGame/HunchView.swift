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
    var viewModel: TableGameViewModel
    @State var selected: Bool = false
    
    var body: some View {
        VStack (alignment: .center) {
            Text("Quantas você faz?")
                .font(Font.custom("Avenir-Medium", size: 18))
                .foregroundColor(Color.white)
            
            HStack {
                ForEach(0 ..< self.choices!.count) { index in
                    Button(action: {
                        withAnimation {
                            self.selected = true
                        }
                        
                        self.viewModel.setChoice(selectedChoice: self.choices![index])
                    }) {
                        Text("\(self.choices![index].number!)")
                    }
                    .padding(2)
                    .disabled(!self.choices![index].available!)
                    .buttonStyle(SelectedButton(selected: self.choices![index].selected!, disabled: !self.choices![index].available!))
                }
            }
            
            if self.selected {
                Button(action: {
                    self.viewModel.setPlayerHunch()
                }) {
                    Text("Enviar")
                }
                .padding(.top, 12)
                .buttonStyle(GoldenButtonStyle())
            }
        }
        .frame(width: 215)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.dark8)
                .shadow(radius: 16)
        )
        .cornerRadius(16)
    }
    
}

struct HunchView_Previews: PreviewProvider {
    static var previews: some View {
        let choices = [Choice](
            arrayLiteral: Choice(number: 1), Choice(number: 2), Choice(number: 3)
        )
        
        HunchView(choices: choices, viewModel: TableGameViewModel(gameId: ""))
    }
}
