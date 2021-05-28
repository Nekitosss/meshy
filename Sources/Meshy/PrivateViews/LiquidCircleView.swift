//
//  LiquidCircleView.swift
//  
//
//  Created by Michael Verges on 8/17/20.
//

import SwiftUI
import Combine

struct LiquidCircleView: View {
    @State var samples: Int
    @State var radians: AnimatableArray
    let period: TimeInterval
    let trigger: Timer.TimerPublisher

    var cancellable: Cancellable?

    init(samples: Int, period: TimeInterval) {
        self._samples = .init(initialValue: samples)
        self._radians = .init(initialValue: AnimatableArray(LiquidCircleView.generateRadial(samples)))
        self.period = period
        self.trigger = Timer.TimerPublisher(interval: period, runLoop: .main, mode: .common)
        self.cancellable = trigger.connect()
    }
    
    var body: some View {
        LiquidCircle(radians: radians)
            .onAnimationCompleted(for: radians, handler: launchAnimation)
            .onAppear(perform: launchAnimation)
    }
    
    private func launchAnimation() {
        schedule(animation: .linear(duration: period)) {
            self.radians = AnimatableArray(LiquidCircleView.generateRadial(self.samples))
        }
    }
    
    static func generateRadial(_ count: Int = 6) -> [Double] {
        
        var radians: [Double] = []
        let offset = Double.random(in: 0...(.pi / Double(count)))
        for i in 0..<count {
            let min = Double(i) / Double(count) * 2 * .pi
            let max = Double(i + 1) / Double(count) * 2 * .pi
            radians.append(Double.random(in: min...max) + offset)
        }
        
        return radians
    }
}
