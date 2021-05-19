//
//  Liquid.swift
//
//
//  Created by Michael Verges on 8/17/20.
//

import SwiftUI
import Combine

/// A flowing, liquid view
public struct Liquid: View {
    
    private let samples: Int
    private let period: TimeInterval
    private let path: CGPath?
    private let interpolate: Int
    
    /// A blob resembling a circle
    /// - Parameters:
    ///   - samples: number of points to sample along the circular path
    ///   - period: length of animation
    public init(samples: Int = 8, period: TimeInterval = 6) {
        self.samples = samples
        self.period = period
        self.path = nil
        self.interpolate = 0
    }
    
    /// A blob resembling a custom path
    /// - Parameters:
    ///   - path: the source path to construct anchor points
    ///   - interpolate: number of points along the path to up-sample
    ///   - samples: the number of samples to select at each animation
    ///   - period: length of animation
    public init(_ path: CGPath, interpolate: Int, samples: Int, period: TimeInterval = 6) {
        assert(interpolate > samples)
        self.path = path
        self.interpolate = interpolate
        self.samples = samples
        self.period = period
    }
    
    public var body: some View {
        if let path = path {
            LiquidPathView(path: path, interpolate: interpolate, samples: samples, period: period)
        } else {
            LiquidCircleView(samples: samples, period: period)
        }
    }
}

struct Liquid_Preview: PreviewProvider {
    static var previews: some View {
        Liquid(samples: 5, period: 6)
            .frame(width: 100, height: 100)
    }
}
