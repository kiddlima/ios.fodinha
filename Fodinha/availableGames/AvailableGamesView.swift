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
    
    @ObservedObject var loginViewModel = LoginViewModel()
    
    @State var showingLogin = false
    @State var showingGame = false
    
    @ObservedObject var viewModel = AvailableGamesViewModel()
    
    @State var isNavigationBarHidden: Bool = true
    
    var body: some View {
        ZStack {
            ActivityIndicator(shouldAnimate: self.$viewModel.loading)
            
            NavigationView {
                List {
                    ForEach(self.viewModel.games, id: \._id) { game in
                        if self.loginViewModel.isLoggedIn {
                            Button(action: {
                                self.showingGame.toggle()
                            }){
                                RowView(game: game)
                                //                                NavigationLink(destination: NavigationLazyView(TableGameView(gameId: game._id!))){
                                //                                    RowView(game: game)
                                //                                }
                            }.fullScreenCover(isPresented: self.$showingGame, content: {
                                TableGameView(gameId: game._id!)
                            })
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
                    trailing:
                        Group {
                            if !self.loginViewModel.isLoggedIn {
                                Button(action: {
                                    withAnimation {
                                        self.showingLogin.toggle()
                                    }
                                }) {
                                    Text("Entrar")
                                        .foregroundColor(.white)
                                    
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
                                        .foregroundColor(Color.dark4)
                                }
                            }
                        }
                )
                .navigationBarTitle(Text("Jogos disponíveis"))
            }
        }.overlay(
            Button(action: {
                
            })
            {
                Text("Criar jogo")
            }
            .cornerRadius(4)
            .buttonStyle(GoldenButtonStyle())
            , alignment: .bottom
        )
        
        .onAppear(){
            UITableView.appearance().backgroundColor = UIColor.dark8
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            UITableViewCell.appearance().backgroundColor = .clear
            UITableView.appearance().separatorStyle = .none
            UITableView.appearance().separatorColor = UIColor.dark8
            
            self.isNavigationBarHidden = true
        }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
