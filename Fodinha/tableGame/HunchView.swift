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
            Text("Quantas rodadas você ganha?")
                .font(Font.custom("Avenir-Medium", size: 18))
                .foregroundColor(Color.white)
            
            HStack {
                ForEach(0 ..< self.choices!.count) { index in
                    Button(action: {
                        if self.selected {
                            self.viewModel.removeChoice()
                            self.choices?.forEach({ choice in
                                choice.selected = false
                            })
                            
                            withAnimation {
                                self.selected = false
                            }
                        } else {
                            withAnimation {
                                self.selected = true
                            }
                            
                            self.viewModel.setChoice(selectedChoice: self.choices![index])
                            
                            self.choices![index].selected = true
                        }
                        
                    }) {
                        Text("\(self.choices![index].number!)")
                    }
                    .animation(.easeOut(duration: 0.4))
                    .padding(2)
                    .disabled(!self.choices![index].available!)
                    .buttonStyle(SelectedButton(selected: self.choices![index].selected!, disabled: !self.choices![index].available!))
                    .isHidden(self.selected && !(self.choices![index].selected!), remove: true)
                    
                }
                
                if self.selected {
                    Button(action: {
                        self.viewModel.setPlayerHunch()
                    }) {
                        Text("Confirmar")
                    }
                    .padding(.top, 2)
                    .padding(.leading, 16)
                    .buttonStyle(GoldenButtonStyle())
                }
            }
        }
        .padding(12)
        .padding(.leading, 16)
        .padding(.trailing, 16)
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
            arrayLiteral: Choice(number: 1)
        )
        
        HunchView(choices: choices, viewModel: TableGameViewModel(gameId: ""))
    }
}
