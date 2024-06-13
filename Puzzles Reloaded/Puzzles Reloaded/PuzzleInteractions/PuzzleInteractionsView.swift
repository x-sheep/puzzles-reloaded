//
//  GestureTransformView.swift
//  Puzzles
//
//  Created by Kyle Swarner on 3/8/24.
//  Copyright © 2024 Kyle Swarner. All rights reserved.
//
import SwiftUI

/// Our UIKit to SwiftUI wrapper view
struct PuzzleInteractionsView: UIViewRepresentable {
    
    // Pan & Zoom transform bound to the puzzle image
    @Binding var transform: CGAffineTransform
    @Binding var anchor: CGPoint
    
    var puzzleFrontend: Frontend
    
    var allowSingleFingerPanning: Bool

    func makeUIView(context: Context) -> PuzzleTapView {
        // Create the underlying UIView, passing in our configuration
        let view = PuzzleTapView()
        
        let zoomRecognizer = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.zoom(_:)))
        
        let panRecognizer = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.pan(_:)))
        
        panRecognizer.minimumNumberOfTouches = allowSingleFingerPanning ? 1 : 2 // Require a two finger touch to prevent conlifct with single taps in the puzzles
        
        zoomRecognizer.delegate = context.coordinator
        panRecognizer.delegate = context.coordinator
        view.addGestureRecognizer(zoomRecognizer)
        view.addGestureRecognizer(panRecognizer)
        context.coordinator.zoomRecognizer = zoomRecognizer
        context.coordinator.panRecognizer = panRecognizer
        context.coordinator.view = view
        
        view.frontend = puzzleFrontend
        view.isSingleFingerNavEnabled = allowSingleFingerPanning
        
        return view
    }
    
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(self)
        coordinator.setupOrientationNotifications()
        return coordinator
            
    }

    func updateUIView(_ uiView: PuzzleTapView, context: Context) {
    }

}
