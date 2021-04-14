//
//  TableGameRepresentable.swift
//  Truquero
//
//  Created by Vinicius Lima on 09/04/21.
//  Copyright © 2021 Vinicius Lima. All rights reserved.
//

import SwiftUI

struct TableGameRepresentable: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIViewController
    var gameId: String
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = MyHostingController(rootView: TableGameView(gameId: self.gameId))
        controller.setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
        controller.setNeedsUpdateOfHomeIndicatorAutoHidden()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        uiViewController.setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
        uiViewController.setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
}
