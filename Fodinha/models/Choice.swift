//
//  Choice.swift
//  Fodinha
//
//  Created by Vinicius Lima on 27/05/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import Foundation
import SwiftUI

class Choice: Decodable {
    
    init(number: Int) {
        self.number = number
    }
    
    var number: Int?
    var selected: Bool? = false
    var available: Bool? = true
}
