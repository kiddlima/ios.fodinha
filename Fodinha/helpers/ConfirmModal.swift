//
//  ConfirmModal.swift
//  Truquero
//
//  Created by Vinicius Lima on 28/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import SwiftUI

struct ConfirmModal: View {
    
    var title: String
    var subtitle: String
    @Binding var loading: Bool
    var cancelAction: () -> Void
    var confirmAction: () -> Void
    
    var body: some View {
        VStack (alignment:. leading) {
            Text("\(title)")
                .font(Font.custom("Avenir-Medium", size: 24))
                .bold()
                .foregroundColor(.white)
            
            Text("\(subtitle)")
                .font(Font.custom("Avenir-Regular", size: 16))
                .foregroundColor(.white)
            
            Spacer()
            
            HStack  {
                Button(action: {
                    self.cancelAction()
                }, label: {
                    Text("Cancelar")
                })
                .buttonStyle(SecondaryButtonStyle())
                
                Button(action: {
                    self.confirmAction()
                }, label: {
                    HStack {
                        Text("Confirmar")
                        
                        if self.loading {
                            ActivityIndicator(shouldAnimate: self.$loading)
                        }
                    }
                })
                .disabled(self.loading)
                .buttonStyle(GoldenButtonStyle())
            }
        }
        .padding()
        .frame(height: 150)
    }
}

struct ConfirmModal_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmModal(title: "Deseja sair do jogo?", subtitle: "Voce ainda poderá voltar para o jogo", loading: .constant(false)) {
            
        } confirmAction: {
            
        }

    }
}
