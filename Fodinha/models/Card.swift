//
//  Card.swift
//  Fodinha
//
//  Created by Vinicius Lima on 08/05/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import Foundation
import Firebase

class Card: Decodable{
    
    init(rank: Int?, suit: String?, value: Int?) {
        self.rank = rank
        self.suit = suit
        self.value = value
        self.imageName = self.suit!.lowercased() + String(self.value!)
    }
    
    init() {
        
    }
    
    var rank: Int?
    var suit: String?
    var value: Int?
    var imageName: String?
    var selected: Bool = false
    
}
