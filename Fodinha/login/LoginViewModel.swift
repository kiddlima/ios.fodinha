//
//  LoginViewModel.swift
//  Fodinha
//
//  Created by Vinicius Lima on 14/05/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import Foundation
import FirebaseAuth
import SwiftUI
import ValidatedPropertyKit
import GoogleSignIn
import FBSDKLoginKit

class LoginViewModel: ObservableObject{
    
    @Published var isLoggedIn: Bool = false
    @Published var loading = false
    
    var facebookManager = LoginManager()
    
    var socialCallback: ((String?) -> Void)?
    
    init() {
        Auth.auth().addStateDidChangeListener { auth, user in
            self.isLoggedIn = user != nil
            
            if !self.isLoggedIn {
                self.facebookManager.logOut()
            } else {
                if user?.providerData[0].providerID != "password" {
                    NetworkHelper().socialLogin(networkDelegate: self)
                }
            }
        }
    }
    
    func login(email: String, password: String, callback: @escaping (((String?) -> Void))) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                callback(error?.localizedDescription)
            } else {
                callback(nil)
            }
        }
    }
    
    func facebookLogin(callback: @escaping (((String?) -> Void))) {
        facebookManager.logIn(permissions: ["public_profile", "email"], from: nil) { result, error in
            if error != nil {
                self.socialCallback!("Erro ao autenticar com Facebook")
            } else {
                if AccessToken.current != nil {
                    
                    let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                    
                    callback(nil)
                    
                    Auth.auth().signIn(with: credential) { firebaseResult, error in
                        if error != nil {
                            callback("Erro ao autenticar com Facebook")
                        }
                    }
                }
            }
        }
    }
}



extension LoginViewModel: NetworkRequestDelegate {
    func success(response: Any?) {
        
    }
    
    func fail(errorMessage: String) {
        
    }
}
