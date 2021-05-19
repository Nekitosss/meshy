//
//  File.swift
//  
//
//  Created by Nikita Patskov on 19.05.2021.
//

import SwiftUI

func schedule(animation: Animation, body: @escaping () -> Void) {
    DispatchQueue.main.async {
        withAnimation(animation, body)
    }
}
