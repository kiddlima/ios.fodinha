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
                        .textContentType(.emailAddress)
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

                            Auth.auth().signIn(withEmail: self.email, password: self.password) { authResult, error in
                                if error == nil {
                                    UserDefaults.standard.set(authResult?.user.uid, forKey: "uid")
                                    UserDefaults.standard.set(authResult?.user.email, forKey: "email")
                                    UserDefaults.standard.set(authResult?.user.displayName, forKey: "name")

                                    self.viewModel.isLoggedIn = true
                                    
                                    self.presentationMode.wrappedValue.dismiss()

                                } else {
                                    self.viewModel.isLoggedIn = false
                                }

                                self.loading = false
                            }
                        } else {
                            self.loading = true
                            
                            Auth.auth().createUser(withEmail: self.email, password: self.password) { authResult, error in
                                if error == nil {
                                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                                    changeRequest?.displayName = self.name
                                    changeRequest?.commitChanges { (error) in
                                        self.isSignUp = false
                                        self.loading = false
                                    }
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
