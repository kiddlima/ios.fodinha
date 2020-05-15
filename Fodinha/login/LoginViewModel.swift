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

class LoginViewModel: ObservableObject {
    
    func login(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
          
//            UserDefaults.standard.set(value: email, forKey: "email")
        }
    }
}
