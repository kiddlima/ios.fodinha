//
//  AvailableGamesViewModel.swift
//  Fodinha
//
//  Created by Vinicius Lima on 20/04/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class AvailableGamesViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var games: [Game] = []
    
    init() {
        getGames()
    }

    func getGames(){
        db.collection("game").getDocuments(completion: { (querySnapshot, error) in
            self.games = []
            
            for snap in (querySnapshot?.documents)! {
                
                DispatchQueue.main.async {
                    self.games.append(Game(document: snap))
                }
                
            }
        })
    } 
}
