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
    @State var joinGameLoading = false
    @State var showingGame = false
    
    @State var gameCreated = false
    
    @State var gameId = ""
    
    @State var password = String()
    @State var hasPassword = false
    
    @State var showPopup = false
    @State var popupMessage = String()
    @State var popupType = ResponsePopupView.ResponseType.normal
    
    var body: some View {
        
        ZStack {
            NavigationView {
                
                ZStack {
                    Color.dark8.edgesIgnoringSafeArea(.all)
                    
                    ScrollView {
                        VStack {
                            if !self.gameCreated {
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
                                        
                                        if !self.hasPassword {
                                            self.password = ""
                                        }
                                        
                                        NetworkHelper().createGame(name: self.name, password: self.password) { gameId, error in
                                            if error != nil {
                                                self.loading = false
                                                
                                                self.showPopup = true
                                                self.popupMessage = error!
                                                self.popupType = .error
                                            } else {
                                                self.gameId = gameId!
                                                
                                                withAnimation {
                                                    self.gameCreated = true
                                                }
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
                            } else {
                                VStack {
                                    Button(action: {
                                        UIPasteboard.general.string = "https://www.truquero.com.br/\(self.gameId)"
                                    }, label: {
                                        Text("truquero.com.br/\(self.gameId)")
                                            .font(Font.custom("Avenir-Regular", size: 14))
                                            .foregroundColor(Color.dark3)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "doc.on.doc.fill")
                                            .foregroundColor(Color.dark3)
                                            .imageScale(.medium)
                                    })
                                    .padding(12)
                                    .border(Color.white)
                                    .cornerRadius(4.0)
                                    
                                    Button(action: {
                                        withAnimation {
                                            self.joinGameLoading = true
                                        }
                                        
                                        NetworkHelper().joinGame(gameId: self.gameId, password: self.password) { error in
                                            if error == nil {
                                                self.showingGame = true
                                            } else {
                                                self.presentationMode.wrappedValue.dismiss()
                                            }
                                        }
                                        
                                    }, label: {
                                        Text("Entrar no jogo")
                                    })
                                    .fullScreenCover(isPresented: self.$showingGame, content: {
                                        TableGameView(gameId: self.gameId)
                                    })
                                    .padding(.top, 16)
                                    .buttonStyle(GoldenButtonStyle())
                                    
                                    Button(action: {
                                        self.presentationMode.wrappedValue.dismiss()
                                    }, label: {
                                        Text("Voltar")
                                    })
                                    .padding(.top, 16)
                                    .buttonStyle(SecondaryButtonStyle())
                                }
                            }
                        }
                        .padding()
                    }
                }
                
                .onTapGesture {
                    self.hideKeyboard()
                }
                .navigationBarTitle(Text(!self.gameCreated ? "Criar jogo" : "Jogo criado!"))
                
            }
            .blur(radius: self.joinGameLoading ? 15 : 0)
            .popup(isPresented: self.$showPopup, type: .floater(verticalPadding: 48), autohideIn: 3){
                ResponsePopupView(message: self.popupMessage, type: self.popupType)
            }
            
            if self.joinGameLoading {
                ZStack {
                    ZStack {
                        Color.dark3.opacity(0.1).edgesIgnoringSafeArea(.all)
                    }
                }
                ZStack {
                    VStack {
                        Text("Entrando no jogo \(self.name)")
                            .font(Font.custom("Avenir-Medium", size: 18))
                            .foregroundColor(Color.dark3)
                            .padding(.bottom, 16)
                        
                        ActivityIndicator(shouldAnimate: .constant(true))
                            .foregroundColor(Color.white)
                    }
                }
            }
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
