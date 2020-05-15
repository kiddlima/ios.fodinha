//
//  LoginView.swift
//  Fodinha
//
//  Created by Vinicius Lima on 14/05/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var viewModel = LoginViewModel()
    
    var body: some View {
        ZStack (alignment: .top){
            Color.customDarkGray
                .edgesIgnoringSafeArea(.all)
            
            VStack (alignment: .leading){
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(4)
                TextField("Senha", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(4)
                
                Button(action: {
                    self.viewModel.login(email: self.email, password: self.password)
                }) {
                    Text("Entrar")
                }.padding()
            }
            .padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
