//
//  ChatTextField.swift
//  Truquero
//
//  Created by Vinicius Lima on 21/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import Foundation
import SwiftUI

struct ChatTextField: UIViewRepresentable {

    @Binding var text: String
    var placeHolder: String
    var chatViewModel: ChatViewModel

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.placeholder = placeHolder

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        
        uiView.font = UIFont.preferredFont(forTextStyle: .body)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(chatViewModel: self.chatViewModel)
    }

    class Coordinator: NSObject, UITextFieldDelegate {

        var chatViewModel: ChatViewModel
        
        init(chatViewModel: ChatViewModel) {
            self.chatViewModel = chatViewModel
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            if let textMessage = textField.text {
                self.chatViewModel.messageToSend = textMessage
            }
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            if let textMessage = textField.text {
                self.chatViewModel.messageToSend = textMessage
            }
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if let textMessage = textField.text {
                self.chatViewModel.messageToSend = textMessage
                
                chatViewModel.sendMessage()
                
                textField.text = ""
            }
            
            textField.resignFirstResponder()
            return true
        }
    }
}
