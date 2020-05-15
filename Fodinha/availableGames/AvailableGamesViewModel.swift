//
//  AvailableGamesViewModel.swift
//  Fodinha
//
//  Created by Vinicius Lima on 20/04/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import SwiftUI
import Firebase

class AvailableGamesViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var games: [Game] = []
    
    init() {
        listenToGames()
    }
    
    func listenToGames(){
        db.collection("game").addSnapshotListener { documentSnapshot, error in
            
            self.games = []
            
            for snap in (documentSnapshot?.documents)! {
                
                DispatchQueue.main.async {
                    self.games.append(Game(document: snap))
                }
                
            }
        }
    } 
}
