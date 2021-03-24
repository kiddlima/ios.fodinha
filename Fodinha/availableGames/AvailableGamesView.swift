//
//  ContentView.swift
//  Fodinha
//
//  Created by Vinicius Lima on 17/04/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var loginViewModel = LoginViewModel()
    
    @State var showingLogin = false
    @State var showingGame = false
    @State var showCreateGame = false
    
    @State var showJoinGamePassword = false
    @State var showJoinGameBlur = false
    @State var joinGamePassword = String()
    
    @ObservedObject var viewModel = AvailableGamesViewModel()
    
    @State var isNavigationBarHidden: Bool = true
    
    @State var showPopup: Bool = false
    @State var popupMessage: String = ""
    @State var popupType: ResponsePopupView.ResponseType = .normal
    
    var body: some View {
        ZStack {
            ActivityIndicator(shouldAnimate: self.$viewModel.loading)
            
            NavigationView {
                List {
                    ForEach(self.viewModel.games, id: \._id) { game in
                        if self.loginViewModel.isLoggedIn {
                            Button(action: {
                                self.viewModel.selectedGame = game
                                
                                if game.hasPassword ?? false && !game.isPlayerInTheGame() {
                                    withAnimation {
                                        self.showJoinGameBlur = true
                                        self.showJoinGamePassword = true
                                    }
                                } else {
                                    if !game.isPlayerInTheGame() {
                                        self.showJoinGamePassword = false
                                        
                                        withAnimation {
                                            self.showJoinGameBlur = true
                                        }
                                        
                                        NetworkHelper().joinGame(gameId: (self.viewModel.selectedGame?._id)!, password: nil) { error in
                                            if error == nil {
                                                self.viewModel.removeListener()
                                                self.showingGame = true
                                            } else {
                                                self.showJoinGameBlur = false
                                            }
                                        }
                                    } else {
                                        self.viewModel.removeListener()
                                        self.showingGame = true
                                    }
                                }
                                
                            }){
                                RowView(game: game)
                            }
                            .buttonStyle(ResizeButtonStyle())
                            .listRowBackground(Color.dark8)
                            
                        } else {
                            Button(action: {
                                self.showingLogin.toggle()
                            }) {
                                RowView(game: game)
                            }.sheet(isPresented: self.$showingLogin) {
                                LoginView(viewModel: self.loginViewModel)
                            }
                            .buttonStyle(ResizeButtonStyle())
                            .listRowBackground(Color.dark8)
                        }
                    }
                }
                
                .listStyle(PlainListStyle())
                .listSeparatorStyle(.none)
                .navigationBarItems(
                    leading: Group {
                        if !self.loginViewModel.isLoggedIn {
                            Button(action: {
                                withAnimation {
                                    self.showingLogin.toggle()
                                }
                            }) {
                                Text("Entrar")
                                    .foregroundColor(Color.dark3)
                                
                            }.sheet(isPresented: $showingLogin) {
                                LoginView(viewModel: self.loginViewModel)
                            }
                            
                        } else {
                            Menu {
                                Button("Sair", action: {
                                    try? Auth.auth().signOut()
                                    
                                    self.loginViewModel.isLoggedIn = false
                                })
                            }
                            label: {
                                Label("\((Auth.auth().currentUser?.displayName ?? ""))", systemImage: "person.circle.fill")
                                    .foregroundColor(Color.dark3)
                            }
                        }
                    }, trailing:
                        Group {
                            if self.loginViewModel.isLoggedIn {
                                Button(action: {
                                    self.showCreateGame = true
                                }){
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(Color.golden0)
                                        .imageScale(.large)
                                }.sheet(isPresented: self.$showCreateGame) {
                                    CreateGameView()
                                }
                            }
                        }
                    
                )
                .navigationBarTitle(Text("Jogos"))
            }
            .fullScreenCover(isPresented: self.$showingGame, content: {
                TableGameView(gameId: (self.viewModel.selectedGame?._id)!)
            })
            .blur(radius: self.showJoinGameBlur ? 25 : 0)
            
            if self.showJoinGameBlur {
                ZStack {
                    ZStack {
                        Color.dark3.opacity(0.1).edgesIgnoringSafeArea(.all)
                    }.onTapGesture {
                        withAnimation {
                            self.showJoinGameBlur.toggle()
                        }
                    }
                    ZStack {
                        VStack {
                            if self.showJoinGamePassword {
                                VStack {
                                    VStack (alignment: .leading){
                                        HStack {
                                            Text("Jogo com senha")
                                                .foregroundColor(Color.white)
                                                .font(.title)
                                                .fontWeight(.bold)
                                            
                                            Spacer()

                                            Image(systemName: "lock.fill")
                                                .foregroundColor(Color.dark5)
                                                .imageScale(.large)
                                        }
                                        .padding(.top, 8)
                                        .padding(.bottom, 16)
                                        
                                        TextField("Senha", text: self.$joinGamePassword)
                                            .textFieldStyle(PrimaryInput(invalid: false))
                                    }
                                    .padding(24)
                                    
                                    Button(action: {
                                        if !self.joinGamePassword.isEmpty {
                                            
                                            self.showJoinGamePassword = false
                                            
                                            NetworkHelper().joinGame(gameId: (self.viewModel.selectedGame?._id)!, password: self.joinGamePassword) { error in
                                                if error == nil {
                                                    self.viewModel.removeListener()
                                                    self.showingGame = true
                                                } else {
                                                    withAnimation {
                                                        self.showJoinGameBlur = false
                                                    }
                                                    
                                                    self.showPopup(message: "Erro ao entrar no jogo", type: .error)
                                                }
                                            }
                                        }
                                    }){
                                        Text("Entrar")
                                    }
                                    .padding(.bottom, 32)
                                    .buttonStyle(GoldenButtonStyle())
                                }
                                .background(Color.dark8.opacity(0.5))
                                .cornerRadius(24)
                                .padding(24)
                                
                            } else {
                                Text("Entrando no jogo \(self.viewModel.selectedGame?.name ?? "")")
                                    .font(Font.custom("Avenir-Medium", size: 18))
                                    .foregroundColor(Color.dark3)
                                    .padding(.bottom, 16)
                                
                                ActivityIndicator(shouldAnimate: .constant(true))
                                    .foregroundColor(Color.white)
                            }
                        }
                    }
                }
            }
        }
        .popup(isPresented: self.$showPopup, type: .floater(verticalPadding: 48), autohideIn: 3){
            ResponsePopupView(message: self.popupMessage, type: self.popupType)
        }
        .onAppear() {
            UITableView.appearance().backgroundColor = UIColor.dark8
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            UITableViewCell.appearance().backgroundColor = .clear
            UITableView.appearance().separatorStyle = .none
            UITableView.appearance().separatorColor = UIColor.dark8
            
            self.isNavigationBarHidden = true
        }
    }
    
    func showPopup(message: String, type: ResponsePopupView.ResponseType) {
        self.popupMessage = message
        self.popupType = type
        withAnimation {
            self.showPopup = true
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RowView: View{
    var game: Game
    
    var body: some View {
        
        LazyVStack{
            HStack{
                VStack(alignment: .leading){
                    Text(game.name!)
                        .foregroundColor(.white)
                        .font(Font.custom("Avenir-Medium", size: 16))
                        .fontWeight(.bold)
                    Text("\(game.players!.count)/8")
                        .font(Font.custom("Avenir-Regular", size: 14))
                        .foregroundColor(Color.customLighter2Gray)
                }
                .padding(16)
                
                Spacer()
                
                if game.hasPassword! {
                    if game.isPlayerInTheGame() {
                        Image("open_padlock").resizable()
                            .frame(width: 15, height: 20)
                            .padding(.trailing, 16)
                    } else {
                        Image("padlock").resizable()
                            .frame(width: 15, height: 20)
                            .padding(.trailing, 16)
                    }
                } else {
                    if game.active! {
                        Image("activeIcon").resizable()
                            .frame(width: 15, height: 15)
                            .padding(.trailing, 16)
                    }
                }
                
            }
        }
        .background(Color.dark6)
        .cornerRadius(8.0)
        .frame(height: 70)
    }
}



