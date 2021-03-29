//
//  ModalView.swift
//  Truquero
//
//  Created by Vinicius Lima on 28/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import SwiftUI

struct ModalView<Content: View>: View {

    @Binding var show: Bool
    let content: Content
    
    init(show: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self._show = show
        self.content = content()
    }
    
    var body: some View {
        if self.show {
            ZStack {
                ZStack {
                    Color.dark3.opacity(0.1).edgesIgnoringSafeArea(.all)
                }.onTapGesture {
                    withAnimation {
                        self.show.toggle()
                    }
                }
                ZStack {
                    VStack {
                        VStack {
                            self.content
                        }
                        .background(Color.dark8.opacity(0.5))
                        .cornerRadius(24)
                        .padding(24)
                    }
                    
                }
            }
        }
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView(show: .constant(true)) {
            
        }
    }
}
