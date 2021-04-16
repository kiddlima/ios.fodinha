//
//  HunchView.swift
//  Fodinha
//
//  Created by Vinicius Lima on 14/05/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import SwiftUI

struct HunchView: View {
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var choices: [Choice]?
    var viewModel: TableGameViewModel
    @State var selected: Bool = false
    
    var body: some View {
        ZStack (alignment: .leading) {
            Capsule()
                .fill(self.viewModel.timeRemainingToPlay > 5 ? Color.dark5 : Color.notificationRed)
                .frame(width: 35, height: 35, alignment: .leading)
                .overlay(
                    Text("\(self.viewModel.timeRemainingToPlay)")
                        .foregroundColor(.white)
                        .font(Font.custom("Avenir-Medium", size: 16))
                        .onReceive(timer) { _ in
                            if self.viewModel.timeRemainingToPlay > 0 {
                                self.viewModel.timeRemainingToPlay -= 1
                            }
                        }
                )
                .animation(.easeInOut(duration: 0.3))
                .shadow(color: Color.black.opacity(0.5), radius: 5, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 2.0)
                .zIndex(1)
                .offset(x: -20)
            
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
            .zIndex(0)
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
    
}

struct HunchView_Previews: PreviewProvider {
    static var previews: some View {
        
        let choices = [Choice](
            arrayLiteral: Choice(number: 1)
        )
        
        HunchView(choices: choices, viewModel: TableGameViewModel(gameId: ""))
    }
}
