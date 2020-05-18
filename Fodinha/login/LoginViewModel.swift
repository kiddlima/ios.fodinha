//
//  LoginViewModel.swift
//  Fodinha
//
//  Created by Vinicius Lima on 14/05/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import SwiftUI

class LoginViewModel: ObservableObject {
    
    @Published var isLoggedIn: Bool = false
    @Published var loading = false
    
    init() {
        isLoggedIn = UserDefaults.standard.string(forKey: "uid") != nil
    }
//    
//    func login(email: String, password: String){
//        
//    }
//    
//    func singUp(email: String, password: String, name: String){
////        
//    }
}
