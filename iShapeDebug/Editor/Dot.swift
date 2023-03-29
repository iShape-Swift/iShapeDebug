//
//  Dot.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 21.03.2023.
//

import SwiftUI

struct Dot: Identifiable {
    
    static let empty = Dot(id: 0, center: .zero, radius: .zero, color: .gray)
    
    let id: Int
    let center: CGPoint
    let radius: CGFloat
    let color: Color

}
