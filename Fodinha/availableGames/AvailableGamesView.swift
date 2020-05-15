//
//  ContentView.swift
//  Fodinha
//
//  Created by Vinicius Lima on 17/04/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var showingLogin = false
    
    init() {
        UITableViewCell.appearance().backgroundColor = UIColor.customDarkGray
        UITableView.appearance().backgroundColor = UIColor.customLightGray
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    }
    
    @ObservedObject var viewModel = AvailableGamesViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.games, id: \.gameId){ game in
                NavigationLink(destination: TableGameView(viewModel: TableGameViewModel(game: game))){
                    RowView(game: game)
                }
            }
            .navigationBarItems(trailing:
                Button(action: {
                    self.showingLogin.toggle()
                    }) {
                        Text("Acessar conta")
                    }.sheet(isPresented: $showingLogin) {
                        LoginView()
            })
            .navigationBarTitle(Text("Jogos disponíveis"))
            .listStyle(GroupedListStyle())
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
