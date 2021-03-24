//
//  TableView.swift
//  Truquero
//
//  Created by Vinicius Lima on 22/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import SwiftUI

struct TableView: View {
    
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: 150, style: .circular)
            .fill(Color.tableDefaultGreen)
            .frame(width: self.width, height: self.height, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 150, style: .circular)
                    .stroke(Color(red: 236/255, green: 234/255, blue: 235/255), lineWidth: 10)
                    .shadow(color: Color.black, radius: 25, x: 0, y: 0)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 150, style: .circular)
                    )).overlay(
                        Image("truquero-water-mark")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
                    )
    }
}

struct TableView_Previews: PreviewProvider {
    static var previews: some View {
        TableView(width: 300, height: 200)
    }
}
