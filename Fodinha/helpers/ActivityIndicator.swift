//
//  ActivityIndicator.swift
//  Fodinha
//
//  Created by Vinicius Lima on 16/05/20.
//  Copyright © 2020 Vinicius Lima. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    
    @Binding var shouldAnimate: Bool
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView()
    }

    func updateUIView(_ uiView: UIActivityIndicatorView,
                      context: Context) {
        if self.shouldAnimate {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}
