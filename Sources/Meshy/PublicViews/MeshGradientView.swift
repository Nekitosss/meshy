//
//  File.swift
//  
//
//  Created by Nikita Patskov on 05.05.2021.
//

import Foundation
import SwiftUI

private struct BlobInfo {
    var radians: AnimatableArray
    var position: CGPoint
}

public struct MeshGradientView: View {
    @State private var samples: Int
    @State private var blob1: BlobInfo
    @State private var blob2: BlobInfo
    @State private var blob3: BlobInfo
    private let period: TimeInterval
    
    private let blob1Gradient: Gradient
    private let blob2Gradient: Gradient
    private let blob3Gradient: Gradient
    
    private let backgroundGradientColors: [Color]
    
    public static let defaultBlob1Gradient = Gradient(colors: [
        Color(red: 230/255, green: 111/255, blue: 91/255),
        Color(red: 228/255, green: 92/255, blue: 84/255)
      ])
    
    public static let defaultBlob2Gradint = Gradient(colors: [
        Color(red: 95/255, green: 161/255, blue: 213/255),
        Color(red: 65/255, green: 125/255, blue: 177/255)
      ])
    
    public static let defaultBlob3Gradient = Gradient(colors: [
        Color(red: 242/255, green: 195/255, blue: 100/255),
        Color(red: 238/255, green: 160/255, blue: 81/255)
      ])
    
    public static let defaultBackgroundColors: [Color] = [
        .red,
        .orange,
        .yellow,
        .green,
        .blue,
        .purple
      ]
    
    public init(samples: Int,
                period: TimeInterval,
                blob1Gradient: Gradient = defaultBlob1Gradient,
                blob2Gradient: Gradient = defaultBlob2Gradint,
                blob3Gradient: Gradient = defaultBlob3Gradient,
                backgroundGradientColors: [Color] = defaultBackgroundColors) {
        
        self._samples = .init(initialValue: samples)
        self.blob1 = Self.randomizeInfo(samples: samples, size: 100)
        self.blob2 = Self.randomizeInfo(samples: samples, size: 100)
        self.blob3 = Self.randomizeInfo(samples: samples, size: 100)
        
        self.period = period
        self.blob1Gradient = blob1Gradient
        self.blob2Gradient = blob2Gradient
        self.blob3Gradient = blob3Gradient
        self.backgroundGradientColors = backgroundGradientColors
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                liquidCircle(info: blob1, gradient: blob1Gradient, size: size(proxy: proxy))
                liquidCircle(info: blob2, gradient: blob2Gradient, size: size(proxy: proxy))
                liquidCircle(info: blob3, gradient: blob3Gradient, size: size(proxy: proxy))
            }
            .onAnimationCompleted(for: blob1.radians, handler: randomizeBlobs)
            .onAnimationCompleted(for: AnimatablePair(blob1.position.x, blob1.position.y)) {
                schedule(animation: .linear(duration: 3 * period)) {
                    randomizePositions(size: proxy.size)
                }
            }
            .onAppear {
                randomizeBlobs()
                randomizePositions(size: proxy.size)
                schedule(animation: .linear(duration: 3 * period)) {
                    randomizePositions(size: proxy.size)
                }
            }
            .background(
                BackgroundGradient(animationDuration: 10 * period, colors: backgroundGradientColors)
            )
            .clipped()
            .blur(radius: max(proxy.size.width, proxy.size.height) / 15, opaque: true)
        }
    }
    
    private func size(proxy: GeometryProxy) -> CGFloat {
        min(proxy.size.width, proxy.size.height)
    }
    
    private var backgroundGradient: Gradient {
        .init(colors: [
            Color(red: 29/255, green: 61/255, blue: 100/255),
            Color(red: 161/255, green: 53/255, blue: 122/255),
            Color(red: 226/255, green: 53/255, blue: 69/255)
        ])
    }
    
    private func liquidCircle(info: BlobInfo, gradient: Gradient, size: CGFloat) -> some View {
        
        LiquidCircle(radians: info.radians)
            .fill(
                LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .frame(width: size / 1.7, height: size / 1.7)
            .position(info.position)
            .opacity(0.7)
    }
    
    private func generateNextBlob() {
        randomizeBlobs()
    }
    
    private func randomizeBlobs() {
        schedule(animation: .linear(duration: period).repeatCount(1, autoreverses: true)) {
            blob1.radians = AnimatableArray(LiquidCircleView.generateRadial(samples))
            blob2.radians = AnimatableArray(LiquidCircleView.generateRadial(samples))
            blob3.radians = AnimatableArray(LiquidCircleView.generateRadial(samples))
        }
    }
    
    private func randomizePositions(size: CGSize) {
        blob1.position = .init(x: .random(in: (size.width/10)...(size.height * 3 / 4)),
                               y: .random(in: (size.height/10)...(size.height / 2)))
        
        blob2.position = .init(x: .random(in: (size.width / 4)...(size.width-size.width/10)),
                               y: .random(in: (size.height / 2)...size.height-size.height/10))
        
        blob3.position = .init(x: .random(in: size.width/10...(size.width - size.width/10)),
                               y: .random(in: size.height/10...(size.height - size.height/10)))
    }
    
    private func randomizePosition(size: CGFloat) -> CGPoint {
        .init(x: CGFloat.random(in: 10...size-10), y: CGFloat.random(in: 10...size-10))
    }
    
    private static func randomizeInfo(samples: Int, size: CGFloat) -> BlobInfo {
        BlobInfo(radians: AnimatableArray(LiquidCircleView.generateRadial(samples)),
                 position: .init(x: CGFloat.random(in: 10...size-10),
                                 y: CGFloat.random(in: 10...size-10)))
    }
}

struct MeshGradientView_Previews: PreviewProvider {
    
    static var previews: some View {
        MeshGradientView(samples: 5, period: 3)
//            .frame(width: 200, height: 200)
            .preferredColorScheme(.dark)
    }
    
}
