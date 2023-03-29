//
//  VectorShape.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 25.03.2023.
//

import SwiftUI
import simd
import iShape

struct Vector: Identifiable {
    
    static let empty = Vector(id: 0, a: .zero, b: .zero)
    
    let id: Int
    let a: CGPoint
    let b: CGPoint
    let eL: CGPoint
    let eR: CGPoint
    
    init(id: Int, a: CGPoint, b: CGPoint, dash: Float = 10, angle: Float = Float.pi / 6) {
        self.id = id
        self.a = a
        self.b = b
        
        let pA = Point(a)
        let pB = Point(b)
        
        let sn = sin(angle)
        let cs = cos(angle)

        let ba = (pB - pA).normalize
        let v = dash * ba

        let mL = Mat2d(cos: cs, sin: sn)
        let mR = Mat2d(cos: cs, sin: -sn)
        
        eL = CGPoint(pB - simd_mul(mL, v))
        eR = CGPoint(pB - simd_mul(mR, v))
    }
    
}

struct VectorShape: SwiftUI.Shape {
    
    let vector: Vector
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: vector.a)
            path.addLine(to: vector.b)
            path.move(to: vector.eL)
            path.addLine(to: vector.b)
            path.addLine(to: vector.eR)
        }
    }

}
