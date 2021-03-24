//
//  Card.swift
//  Fodinha
//
//  Created by Vinicius Lima on 08/05/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import Foundation
import Firebase

struct Card: Decodable, Hashable{
    
    init(rank: Int?, suit: String?, value: Int?) {
        self.rank = rank
        self.suit = suit
        self.value = value
        self.imageName = self.suit!.lowercased() + String(self.value!)
    }
    
    init(data: [String: Any]) {
        self.rank = data["rank"] as? Int
        self.suit = data["suit"] as? String
        self.value = data["value"] as? Int
        
        self.imageName = self.suit!.lowercased() + String(self.value!)
    }
    
    var id: UUID = UUID()
    var rank: Int?
    var suit: String?
    var value: Int?
    var imageName: String?
    var selected: Bool = false
    
}
