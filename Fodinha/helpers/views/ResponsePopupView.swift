//
//  ResponsePopupView.swift
//  Truquero
//
//  Created by Vinicius Lima on 16/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import SwiftUI

struct ResponsePopupView: View {
    
    enum ResponseType {
        case success
        case error
        case warning
        case normal
    }
    
    var message: String
    private var backgroundColor: Color?
    
    init(message: String?, type: ResponseType?) {
        self.message = message ?? ""
        
        switch type {
        case .success:
            self.backgroundColor = Color.notificationGreen
        case .error:
            self.backgroundColor = Color.notificationRed
        case .warning:
            self.backgroundColor = Color.yellow
        default:
            self.backgroundColor = Color.customLightGray
        }
    }
    
    var body: some View {
        HStack {
            Text("\(message)")
                .font(Font.custom("Avenir-Medium", size: 16))
                .bold()
                .foregroundColor(.black)
        }
        .frame(height: 30)
        .padding(.all, 8)
        .padding(.leading, 24)
        .padding(.trailing, 24)
        .background(self.backgroundColor)
        .cornerRadius(64)
    }
}

struct ResponsePopupView_Previews: PreviewProvider {
    static var previews: some View {
        ResponsePopupView(message: "Teste de notificação", type: .success)
    }
}
