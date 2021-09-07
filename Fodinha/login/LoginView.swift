//
//  LoginView.swift
//  Fodinha
//
//  Created by Vinicius Lima on 14/05/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import ValidatedPropertyKit
import FBSDKLoginKit
import FBSDKCoreKit

struct LoginView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: LoginViewModel
    
    @Validated(.isEmail)
    var email = String()
    
    @Validated(!.isEmpty)
    var password = String()
    
    @Validated(.range(3...))
    var name = String()
    
    @Validated(.range(3...))
    var confirmPassword = String()
    
    @State var loading: Bool = false
    @State var isSignUp: Bool = false
    
    @State var showPopup: Bool = false
    @State var popupMessage: String = ""
    @State var popupType: ResponsePopupView.ResponseType = .normal
    
    @State var shouldDissmiss: Bool = false {
        didSet {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        
        GIDSignIn.sharedInstance().presentingViewController = UIApplication.shared.windows.first?.rootViewController
        
        let mutating = self
        
        Auth.auth().addStateDidChangeListener { auth, user in
            mutating.presentationMode.wrappedValue.dismiss()
        }
    }
    
    var body: some View {
        ZStack (alignment: .top){
            Color.dark6
                .edgesIgnoringSafeArea(.all)
            
            AuthDelegates { error in
                if error != nil {
                    self.popupMessage = "Erro ao autenticar com Google"
                    self.popupType = .error
                    self.showPopup = true
                    
                    self.loading = false
                } else {
                    self.loading = true
                }
            }
            
            ScrollView {
                VStack (alignment: .center){
                    
                    Image("brand")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 70)
                        .padding(32)
                    
                    TextField("", text: self.$email)
                        .textFieldStyle(PrimaryInput(invalid: !self._email.isValid))
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .textContentType(.emailAddress)
                        .placeholder(when: email.isEmpty) {
                               Text("Email")
                                .padding(.leading, 16)
                                .foregroundColor(.customLighterGray)
                       }
                    
                    if self.isSignUp {
                        TextField("", text: self.$name)
                            .textFieldStyle(PrimaryInput(invalid: !self._name.isValid))
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .textContentType(.name)
                            .placeholder(when: name.isEmpty) {
                                   Text("Nome")
                                    .padding(.leading, 16)
                                    .foregroundColor(.customLighterGray)
                           }
                    }
                    
                    SecureField("", text: self.$password)
                        .textFieldStyle(PrimaryInput(invalid: !self._password.isValid))
                        .textContentType(.password)
                        .autocapitalization(.none)
                        .placeholder(when: password.isEmpty) {
                               Text("Senha")
                                .padding(.leading, 16)
                                .foregroundColor(.customLighterGray)
                       }
                    
                    
                    if self.isSignUp {
                        SecureField("", text: self.$confirmPassword)
                            .textFieldStyle(PrimaryInput(invalid: false))
                            .textContentType(.password)
                            .autocapitalization(.none)
                            .placeholder(when: confirmPassword.isEmpty) {
                                   Text("Confirmar senha")
                                    .padding(.leading, 16)
                                    .foregroundColor(.customLighterGray)
                           }
                    }
                    
                    VStack {
                        Button(action: {
                            UIApplication.shared.endEditing()
                            
                            if self.isFormValid(isSignUp: isSignUp){
                                if !self.isSignUp {
                                    withAnimation {
                                        self.loading = true
                                    }
                                    
                                    self.viewModel.login(email: self.email, password: self.password) { error in
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
                                    
                                    NetworkHelper().register(name: name, email: email, password: password) { (response: String?) in
    
                                        self.viewModel.login(email: self.email, password: self.password) { error in
                                            
                                            if error == nil {
                                                withAnimation {
                                                    self.viewModel.isLoggedIn = true
                                                    
                                                    self.presentationMode.wrappedValue.dismiss()
                                                }
                                            } else {
                                                withAnimation {
                                                    self.loading = false
                                                }
                                            }
                                        }
                                    }
                                }
                            } else {
                                self.popupMessage = "Campos inválidos"
                                self.popupType = .error
                                self.showPopup = true
                            }
                        }) {
                            Text(!self.isSignUp ? "Entrar" : "Cadastrar")
                        }
                        .goldenStyle()
                        .cornerRadius(8)
                        .padding()
                        
                        if !self.isSignUp {
                            
                            Button(action: {
                                
                                if self._email.isValid {
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
                                } else {
                                    self.popupMessage = "Email inválido"
                                    self.popupType = .error
                                    self.showPopup = true
                                }
                            }) {
                                Text("Esqueci a senha")
                            }
                            .disabled(!self._email.isValid)
                            .buttonStyle(SecondaryButtonStyle())
                        }
                        
                        ActivityIndicator(shouldAnimate: $loading)
                    }
                    
                    if !self.isSignUp {
                        Divider()
                            .background(Color.dark4)
                            .padding(.bottom, 16)
                        
                        Button(action: {
                            GIDSignIn.sharedInstance().signIn()
                        }){
                            Image("google-icon")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 16)
                                .padding(.trailing, 8)
                            
                            Text("Continuar com Google")
                                .font(Font.custom("Avenir-Medium", size: 18))
                                .foregroundColor(Color.customLightGray)
                        }
                        .frame(minWidth: 0, maxWidth: 300, minHeight: 40, idealHeight: 40, maxHeight: 40,
                               alignment: .center)
                        .background(Color.white)
                        .cornerRadius(4)
                        
                        Button(action: {
                            self.viewModel.facebookLogin { error in
                                if error != nil {
                                    self.popupMessage = error!
                                    self.popupType = .error
                                    self.showPopup = true
                                    
                                    self.loading = false
                                } else {
                                    self.loading = true
                                }
                            }
                        }){
                            Image("facebook-icon")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 16)
                                .padding(.trailing, 8)

                            Text("Continuar com Facebook")
                                .font(Font.custom("Avenir-Medium", size: 18))
                                .foregroundColor(Color.white)
                        }
                        .frame(minWidth: 0, maxWidth: 300, minHeight: 40, idealHeight: 40, maxHeight: 40,
                               alignment: .center)
                        .background(Color.facebookBlue)
                        .cornerRadius(4)
                        
                        AppleLoginButton(didComplete: { error in
                            if error != nil {
                                self.popupMessage = "Erro ao autenticar com Apple"
                                self.popupType = .error
                                self.showPopup = true
                                
                                self.loading = false
                            } else {
                                self.loading = true
                            }
                        })
                            .frame(minWidth: 0, maxWidth: 300, minHeight: 45, idealHeight: 45, maxHeight: 45, alignment: .center)
                        
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
        }
        .onTapGesture {
            self.hideKeyboard()
        }
        .popup(isPresented: self.$showPopup, type: .floater(verticalPadding: 48), autohideIn: 3){
            ResponsePopupView(message: self.popupMessage, type: self.popupType)
        }
    }
    
    func isFormValid(isSignUp: Bool) -> Bool {
        var formValid = false
        
        if isSignUp {
            let fieldsValid = self._email.isValid && self._password.isValid && self._name.isValid
            
            if fieldsValid {
                if self.password == self.confirmPassword {
                    formValid = true
                }
            }
        } else {
            formValid = self._email.isValid && self._password.isValid
        }
        
        return formValid
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
