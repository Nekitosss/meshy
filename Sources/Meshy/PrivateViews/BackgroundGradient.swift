//
//  File.swift
//  
//
//  Created by Nikita Patskov on 19.05.2021.
//

import SwiftUI

struct BackgroundGradient: View {
    @State private var gradientAngle: Double = .random(in: 0...360)
    
    let animationDuration: TimeInterval
    let colors: [Color]
    
    var body: some View {
        Rectangle()
            .fill(
                AngularGradient(gradient: Gradient(colors: colors), center: .center, angle: .degrees(gradientAngle))
            )
            .onAppear {
                schedule(animation: .linear(duration: animationDuration).repeatForever(autoreverses: false)) {
                    self.gradientAngle = 360 + gradientAngle
                }
            }
    }
}

struct BackgroundGradient_Previews: PreviewProvider {
    
    static var previews: some View {
        BackgroundGradient(animationDuration: 3, colors: [
            .red,
            .orange,
            .yellow,
            .green,
            .blue,
            .purple
        ])
        .blur(radius: 30, opaque: true)
        .frame(width: 200, height: 200)
    }
    
}
