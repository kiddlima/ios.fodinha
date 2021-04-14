//
//  MyHostingViewController.swift
//  Truquero
//
//  Created by Vinicius Lima on 09/04/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import Foundation
import SwiftUI

class MyHostingController<Content: View>: UIHostingController<Content> {
    open override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge{
        return [.bottom];
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return false
    }
}
