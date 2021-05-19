//
//  File.swift
//  
//
//  Created by Nikita Patskov on 05.05.2021.
//

import Foundation
import SwiftUI

/// Class observes animation change and when animation completed.
/// After some testing recognize that animatable ViewModifier not work.
struct AnimationCompletionShape<Value: VectorArithmetic>: Shape {
    
    var animatableData: Value {
        get { observingValue }
        set {
            observingValue = newValue
            if observingValue == targetValue {
                DispatchQueue.main.async(execute: handler)
            }
        }
    }
    
    let targetValue: Value
    let handler: () -> Void
    var observingValue: Value
    
    init(targetValue: Value, handler: @escaping () -> Void) {
        self.targetValue = targetValue
        self.handler = handler
        self.observingValue = targetValue
    }
    
    func path(in rect: CGRect) -> Path {
        .init()
    }
    
}

extension View {

    /// Calls the completion handler whenever an animation on the given value completes.
    /// - Parameters:
    ///   - value: The value to observe for animations.
    ///   - completion: The completion callback to call once the animation completes.
    /// - Returns: A modified `View` instance with the observer attached.
    func onAnimationCompleted<Value: VectorArithmetic>(for targetValue: Value, handler: @escaping () -> Void) -> some View {
        background(AnimationCompletionShape(targetValue: targetValue, handler: handler))
    }
}
