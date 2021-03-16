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
    @State var confirmPassword: String = ""
    @State var password: String = ""
    
    @State var showPopup: Bool = false
    @State var popupMessage: String = ""
    @State var popupType: ResponsePopupView.ResponseType = .normal
    
    @State var shouldDissmiss: Bool = false {
        didSet {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    var body: some View {
        ZStack (alignment: .top){
            Color.dark6
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack (alignment: .center){
                    
                    Image("brand")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 70)
                        .padding(32)
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(PrimaryInput())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .textContentType(.emailAddress)
                    
                    if self.isSignUp {
                        TextField("Nome", text: $name)
                            .textFieldStyle(PrimaryInput())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .textContentType(.name)
                    }
                    
                    SecureField("Senha", text: $password)
                        .textFieldStyle(PrimaryInput())
                        .textContentType(.password)
                        .autocapitalization(.none)
                    
                    
                    if self.isSignUp {
                        SecureField("Confirmar senha", text: $confirmPassword)
                            .textFieldStyle(PrimaryInput())
                            .textContentType(.password)
                            .autocapitalization(.none)
                    }
                    
                    VStack {
                        Button(action: {
                            
                            UIApplication.shared.endEditing()
                            
                            if !self.isSignUp {
                                withAnimation {
                                    self.loading = true
                                }
                                
                                Auth.auth().signIn(withEmail: self.email, password: self.password) { data, error in
                                    if error == nil {
                                        
                                        self.viewModel.isLoggedIn = true
                                        
                                        self.presentationMode.wrappedValue.dismiss()
                                    } else {
                                        self.popupMessage = "Email ou senha inválidos"
                                        self.popupType = .error
                                        self.showPopup = true
                                        
                                        self.viewModel.isLoggedIn = false
                                    }
                                    
                                    withAnimation {
                                        self.loading = false
                                    }
                                }
                                
                            } else {
                                withAnimation {
                                    self.loading = true
                                }
                                
                                NetworkHelper().register(name: name, email: email, password: password, username: confirmPassword) { (response: String?) in
                                    
                                    if response != nil {
                                        withAnimation {
                                            self.isSignUp = false
                                            self.loading = false
                                        }
                                    } else {
                                        withAnimation {
                                            self.loading = false
                                        }
                                    }
                                    
                                }
                            }
                            
                        }) {
                            Text(!self.isSignUp ? "Entrar" : "Cadastrar")
                        }
                        .cornerRadius(8)
                        .buttonStyle(GoldenButtonStyle())
                        .padding()
                        
                        if !self.isSignUp {
                            
                            Button(action: {
                                self.loading = true
                                
                                UIApplication.shared.endEditing()
                                
                                Auth.auth().sendPasswordReset(withEmail: self.email) { error in
                                    self.loading = false
                                    
                                    if error != nil {
                                        self.popupMessage = "Erro ao redefinir senha"
                                        self.popupType = .error
                                        self.showPopup = true
                                        
                                    } else {
                                        self.popupMessage = "Enviado email para redefinir senha"
                                        self.popupType = .success
                                        self.showPopup = true
                                    }
                                    
                                    self.showPopup = true
                                }
                            }) {
                                Text("Esqueci a senha")
                            }
                            .buttonStyle(SecondaryButtonStyle())
                        }
                        
                        ActivityIndicator(shouldAnimate: $loading)
                    }
                    
                    
                    if !self.isSignUp {
                        Divider()
                            .background(Color.dark4)
                            .padding(.bottom, 16)
                        
                        Button(action: {
                            
                        }){
                            Image("google-icon")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 24)
                                .padding(.trailing, 8)
                            
                            Text("Continuar com Google")
                                .font(Font.custom("Avenir-Medium", size: 16))
                                .foregroundColor(Color.customLightGray)
                        }
                        .frame(minWidth: 0, maxWidth: 300, minHeight: 40, idealHeight: 40, maxHeight: 40,
                               alignment: .center)
                        .background(Color.white)
                        .cornerRadius(4)
                        
                        Button(action: {
                            
                        }){
                            Image("facebook-icon")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 24)
                                .padding(.trailing, 8)
                            
                            Text("Continuar com Facebook")
                                .font(Font.custom("Avenir-Medium", size: 16))
                                .foregroundColor(Color.white)
                        }
                        .frame(minWidth: 0, maxWidth: 300, minHeight: 40, idealHeight: 40, maxHeight: 40,
                               alignment: .center)
                        .background(Color.facebookBlue)
                        .cornerRadius(4)
                        
                        Button(action: {
                            
                        }){
                            Image("apple-icon")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 24)
                                .padding(.trailing, 8)
                            
                            Text("Continuar com Apple")
                                .font(Font.custom("Avenir-Medium", size: 16))
                                .foregroundColor(Color.white)
                        }
                        .frame(minWidth: 0, maxWidth: 300, minHeight: 40, idealHeight: 40, maxHeight: 40,
                               alignment: .center)
                        .background(Color.black)
                        .cornerRadius(4)
                        
                    }
                
                    Button(action: {
                        withAnimation {
                            self.isSignUp.toggle()
                        }
                    }) {
                        if self.isSignUp {
                            Text("Já possuo conta")
                        } else {
                            Text("Criar conta")
                        }
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    .padding()
                    
                }
                .padding()
            }
        }.popup(isPresented: self.$showPopup, type: .floater(verticalPadding: 48), autohideIn: 3){
            ResponsePopupView(message: self.popupMessage, type: self.popupType)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
