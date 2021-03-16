//
//  LoginView.swift
//  Fodinha
//
//  Created by Vinicius Lima on 14/05/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: LoginViewModel
    
    @State var loading: Bool = false
    @State var isSignUp: Bool = false
    
    @State var email: String = ""
    @State var name: String = ""
    @State var username: String = ""
    @State var password: String = ""
    
    var shouldDissmiss: Bool = false {
        didSet {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
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
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)
                    .padding(8)
                
                if self.isSignUp {
                    TextField("Nome", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .textContentType(.name)
                        .padding(8)
                    
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .textContentType(.username)
                        .padding(8)
                }
                    
                SecureField("Senha", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.password)
                    .autocapitalization(.none)
                    .padding(8)
                
                if !self.isSignUp {
                    Button(action: {
                        self.isSignUp = true
                    }) {
                        Text("Criar conta")
                    }.padding()
                }
                
                HStack {
                    Button(action: {
                        
                        if !self.isSignUp {
                            self.loading = true
                            
                            NetworkHelper().login(user: self.email, password: self.password) { (response: String?) in
                                if response != nil {
                                    self.viewModel.isLoggedIn = true
                                    
                                    self.presentationMode.wrappedValue.dismiss()
                                } else {
                                    self.viewModel.isLoggedIn = false
                                }
                                
                                self.loading = false
                            }

                        } else {
                            self.loading = true
                            
                            NetworkHelper().register(name: name, email: email, password: password, username: username) { (response: String?) in
                                
                                if response != nil {
                                    self.isSignUp = false
                                    self.loading = false
                                } else {
                                    self.loading = false
                                }
                                
                            }
                        }
                        
                    }) {
                        Text(!self.isSignUp ? "Entrar" : "Cadastrar")
                    }.padding()

                    ActivityIndicator(shouldAnimate: $loading)
                }
                
            }
            .padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
