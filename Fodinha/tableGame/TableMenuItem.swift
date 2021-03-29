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
    @Binding var notification: Bool
    
    var icon: String?
    var systemName: String?
    
    var selected: () -> Void
    
    init(active: Binding<Bool>, notification: Binding<Bool>, systemName: String, selected: @escaping () -> Void) {
        self._active = active
        self._notification = notification
        self.systemName = systemName
        self.selected = selected
    }
    
    init(icon: String, active: Binding<Bool>, notification: Binding<Bool>, selected: @escaping () -> Void) {
        self.selected = selected
        self.icon = icon
        self._active = active
        self._notification = notification
        
        if self.active {
            if let menuIcon = self.icon {
                self.icon = "\(menuIcon)-dark8"
            }
        }
    }
    
    var body: some View {
        Button(action: {
            self.selected()
            
            withAnimation {
                self.notification = false
            }
        }){
            ZStack {
                Capsule()
                    .foregroundColor(self.active ? Color.golden0 : Color.dark5)
                    .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .cornerRadius(.infinity)
            }
            .overlay(
                Group {
                    if self.systemName != nil {
                    Image(systemName: self.systemName!)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.dark3)
                            .frame(height: 16)
                    } else {
                        Image(icon!)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 16)
                    }
                }
            )
            .overlay(
                Group {
                    if self.notification && !self.active {
                        Capsule()
                            .fill(Color.red)
                            .frame(width: 15, height: 15, alignment: .trailing)
                            .shadow(color: Color/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.4), radius: 2, x: 0.0, y: 0.0)
                    }
                }.frame(width: 50, height: 50, alignment: .topTrailing)
            )
        }
    }
}

struct TableMenuItem_Previews: PreviewProvider {
    static var previews: some View {
        TableMenuItem(icon: "chat", active: .constant(true), notification: .constant(true), selected: {
            
        })
    }
}
