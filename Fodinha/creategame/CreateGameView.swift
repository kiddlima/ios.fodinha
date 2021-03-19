//
//  CreateGameView.swift
//  Truquero
//
//  Created by Vinicius Lima on 17/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import SwiftUI
import ValidatedPropertyKit

struct CreateGameView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Validated(!.isEmpty)
    var name = String()
    
    @State var loading = false
    
    @State var password = String()
    @State var hasPassword = false
    
    @State var showPopup = false
    @State var popupMessage = String()
    @State var popupType = ResponsePopupView.ResponseType.normal
    
    var body: some View {
        NavigationView {
            
            ZStack {
                Color.dark8.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack {
                        TextField("Nome", text: self.$name)
                            .textFieldStyle(PrimaryInput(invalid: false))
                        
                        Toggle(isOn: self.$hasPassword.animation(), label: {
                            Image(systemName: "lock.fill")
                                .foregroundColor(Color.dark3)
                            
                            Text("Jogo com senha?")
                                .foregroundColor(Color.dark3)
                        })
                        .toggleStyle(SwitchToggleStyle(tint: Color.dark3))
                        .padding(.top, 16)
                        .padding(.bottom, 16)
                        
                        if self.hasPassword {
                            TextField("Senha", text: self.$password)
                                .textFieldStyle(PrimaryInput(invalid: false))
                        }
                        
                        Button(action: {
                            if self.fieldsAreValid() {
                                self.loading.toggle()
                                
                                UIApplication.shared.endEditing()
                                
                                NetworkHelper().createGame(name: self.name, password: self.password) { error in
                                    if error != nil {
                                        self.loading = false
                                        
                                        self.showPopup = true
                                        self.popupMessage = error!
                                        self.popupType = .error
                                    } else {
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            } else {
                                self.showPopup = true
                                self.popupMessage = "Campos inválidos"
                                self.popupType = .error
                            }
                        }, label: {
                            Text("Criar")
                        })
                        .padding(.top, 32)
                        .padding(.bottom, 32)
                        .buttonStyle(GoldenButtonStyle())
                        
                        ActivityIndicator(shouldAnimate: $loading)
                        
                    }
                    .padding()
                }
            }
            .onTapGesture {
                self.hideKeyboard()
            }
            .navigationBarTitle(Text("Criar jogo"))
            
        }
        .popup(isPresented: self.$showPopup, type: .floater(verticalPadding: 48), autohideIn: 3){
            ResponsePopupView(message: self.popupMessage, type: self.popupType)
        }
        
        .onAppear {
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        }
        
        
    }
    
    func fieldsAreValid() -> Bool {
        if self._name.isValid {
            if self.hasPassword  {
                if !self.password.isEmpty {
                    return true
                } else {
                    return false
                }
                
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
}



struct CreateGameView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGameView()
    }
}
