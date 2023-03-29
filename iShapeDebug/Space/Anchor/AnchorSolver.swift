//
//  AnchorSolver.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 25.03.2023.
//

import iShape
import simd

struct AnchorSolver {

    static func point(a: Point, b: Point, aL: Float, bL: Float) -> Point {
        let ab = b - a
        let qC = ab.sqrLength()
        let qA = aL * aL
        let qB = bL * bL
        let cL = qC.squareRoot()
        
        let cs = (qC + qB - qA) / (2 * bL * cL)
        let sn = (1 - cs * cs).squareRoot()
        
        let m = Mat2d(cos: cs, sin: sn)
        
        let k = bL / cL
        
        let v = k * ab

        let p = a + simd_mul(m, v)
        
        return p
    }
    
    
}
