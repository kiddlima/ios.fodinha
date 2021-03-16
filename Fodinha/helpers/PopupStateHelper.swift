//
//  PopupStateHelper.swift
//  Truquero
//
//  Created by Vinicius Lima on 16/03/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import Foundation
import SwiftUI

class PopupStateHelper {
    
    var type: ResponsePopupView.ResponseType?
    var message: String?
    
    func show(message: String, type: ResponsePopupView.ResponseType) {
        self.message = message
        self.type = type
    }
}
