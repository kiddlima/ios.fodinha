//
//  AuthDelegates.swift
//  Truquero
//
//  Created by Vinicius Lima on 17/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import Foundation
import AuthenticationServices
import SwiftUI
import GoogleSignIn
import FirebaseAuth

struct AuthDelegates: UIViewControllerRepresentable {
    
    var didComplete: (String?) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewController: UIViewController(), didComplete: didComplete)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return UIViewController()
    }
    
    class Coordinator: NSObject, GIDSignInDelegate {
        var didComplete: (String?) -> Void
        
        fileprivate var currentNonce: String?
        
        init(viewController: UIViewController, didComplete: @escaping (String?) -> Void) {
            self.didComplete = didComplete
            
            super.init()
            
            GIDSignIn.sharedInstance()?.delegate = self
        }
       
        func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
            if error != nil {
                return
            }
            
            self.didComplete(nil)
            
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                           accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { result, error in
                if error != nil {
                    self.didComplete(error?.localizedDescription)
                }
            }
        }
    }
    
}
