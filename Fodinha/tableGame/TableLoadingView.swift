//
//  TableLoadingView.swift
//  Truquero
//
//  Created by Vinicius Lima on 08/04/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import SwiftUI

struct TableLoadingView: View {
    var body: some View {
        ZStack() {
            Color.dark8.edgesIgnoringSafeArea(.all)
            
            VStack{
                Image("brand")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 64)
                    .padding()
                
                ActivityIndicator(shouldAnimate: .constant(true))
            }
        }
    }
}

struct TableLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        TableLoadingView()
    }
}
