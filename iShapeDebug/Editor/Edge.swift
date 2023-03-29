//
//  Edge.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 18.03.2023.
//

import SwiftUI

struct Edge: Identifiable {
    
    static let empty = Edge(id: 0, a: .zero, b: .zero, color: .gray)
    
    let id: Int
    let a: CGPoint
    let b: CGPoint
    let color: Color
}
