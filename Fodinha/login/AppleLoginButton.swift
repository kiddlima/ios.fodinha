//
//  AppleLoginButton.swift
//  Truquero
//
//  Created by Vinicius Lima on 17/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import Foundation
import SwiftUI
import AuthenticationServices
import FirebaseAuth
import CryptoKit

struct AppleLoginButton: UIViewRepresentable {
    
    var didComplete: (String?) -> Void
    
    func makeCoordinator() -> AppleSignInCoordinator {
        return AppleSignInCoordinator(parent: self, didComplete: didComplete)
    }
    
    func makeUIView(context: Context) -> UIView {
        //Creating the apple sign in button
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .continue,
        authorizationButtonStyle: .black)
        button.cornerRadius = 4
        
        //Adding the tap action on the apple sign in button
        button.addTarget(context.coordinator,action: #selector(AppleSignInCoordinator.didTapButton),for: .touchUpInside)
        
        return button
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    class AppleSignInCoordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
        
        var parent: AppleLoginButton
        
        var didComplete: (String?) -> Void
        
        fileprivate var currentNonce: String?
        
        init(parent: AppleLoginButton, didComplete: @escaping (String?) -> Void) {
            self.didComplete = didComplete
            self.parent = parent
            super.init()
        }
        
        @objc func didTapButton() {
            let nonce = AppleAuthHelper.randomNonceString()
            currentNonce = nonce
            
            //Create an object of the ASAuthorizationAppleIDProvider
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            //Create a request
            let request = appleIDProvider.createRequest()
            //Define the scope of the request
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)
            //Make the request
            let authorizationController =
                ASAuthorizationController(authorizationRequests: [request])
            authorizationController.presentationContextProvider = self
            authorizationController.delegate = self
            authorizationController.performRequests()
        }
        
        @available(iOS 13, *)
        private func sha256(_ input: String) -> String {
            let inputData = Data(input.utf8)
            let hashedData = SHA256.hash(data: inputData)
            let hashString = hashedData.compactMap {
                return String(format: "%02x", $0)
            }.joined()
            
            return hashString
        }
        
        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            let vc = UIApplication.shared.windows.last?.rootViewController
            return (vc?.view.window!)!
        }
        
        func authorizationController(controller: ASAuthorizationController,didCompleteWithAuthorization authorization: ASAuthorization)
        {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identity token")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                
                // Initialize a Firebase credential.
                let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                          idToken: idTokenString,
                                                          rawNonce: nonce)
                
                self.didComplete(nil)
                
                // Sign in with Firebase.
                Auth.auth().signIn(with: credential) { authResult, error in
                    if error != nil {
                        self.didComplete(error?.localizedDescription)
                        return
                    }
                }
            }
        }
        
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error)
        {
            
        }
    }
    
}

