//
//  TableMenuItem.swift
//  Truquero
//
//  Created by Vinicius Lima on 19/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import SwiftUI

struct TableMenuItem: View {
    
    @Binding var active: Bool
    
    var icon: String
    
    var selected: () -> Void
    
    init(icon: String, active: Binding<Bool>, selected: @escaping () -> Void) {
        self.selected = selected
        self.icon = icon
        self._active = active
        
        if self.active {
            self.icon = "\(self.icon)-dark8"
        }
    }
    
    var body: some View {
        Button(action: {
            self.selected()
        }){
            ZStack {
                Capsule()
                    .foregroundColor(self.active ? Color.golden0 : Color.dark5)
                    .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .cornerRadius(.infinity)
            }
            .animation(.easeInOut(duration: 0.2))
            .overlay(
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 16)
            )
        }
    }
}

struct TableMenuItem_Previews: PreviewProvider {
    static var previews: some View {
        TableMenuItem(icon: "chat", active: .constant(true), selected: {
            
        })
    }
}
