//
//  ContentView.swift
//  Fodinha
//
//  Created by Vinicius Lima on 17/04/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = AvailableGamesViewModel()
    @ObservedObject var loginViewModel = LoginViewModel()
    
    @State var showingLogin = false
    @State var showingGame = false
    
    var body: some View {
        NavigationView {
            List(viewModel.games, id: \.gameId){ game in
                if self.loginViewModel.isLoggedIn {
                    NavigationLink(destination: NavigationLazyView(TableGameView(game: game))){
                        RowView(game: game)
                    }
                } else {
                    Button(action: {
                        self.showingLogin.toggle()
                    }) {
                        RowView(game: game)
                    }.sheet(isPresented: self.$showingLogin) {
                        LoginView(viewModel: self.loginViewModel)
                    }
                }
            }
            .navigationBarItems(leading: loginViewModel.isLoggedIn ? Text(UserDefaults.standard.string(forKey: "name")!) : Text(""),
                trailing:
                Button(action: {
                    if self.loginViewModel.isLoggedIn {
                        UserDefaults.standard.set(nil, forKey: "uid")
                        UserDefaults.standard.set(nil, forKey: "email")
                        
                        self.loginViewModel.isLoggedIn = false
                    } else {
                        self.showingLogin.toggle()
                    }
                }) {
                    Text(loginViewModel.isLoggedIn ? "Sair" : "Entrar")
                }.sheet(isPresented: $showingLogin) {
                    LoginView(viewModel: self.loginViewModel)
                })
            .navigationBarTitle(Text("Jogos disponíveis"))
            .listStyle(GroupedListStyle())
        }
        .onAppear(){
            UITableViewCell.appearance().backgroundColor = UIColor.customDarkGray
            UITableView.appearance().backgroundColor = UIColor.customLightGray
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        }
    }
}

struct RowView: View{
    var game: Game
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(game.name!)
                    .foregroundColor(.white)
                Text("Criado por: \(game.createdBy!)")
                    .foregroundColor(Color.customLighterGray)
            }
            
            Spacer()
        
            if game.active! {
                Image("activeIcon").resizable()
                    .foregroundColor(Color.tableDefaultGreen)
                .frame(width: 15, height:
                    15)
            }
        }
        .frame(height: 56)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
