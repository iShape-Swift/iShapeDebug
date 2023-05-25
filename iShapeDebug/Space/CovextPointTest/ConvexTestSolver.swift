//
//  ConvexTestSolver.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 03.05.2023.
//

import iSpace

public struct ConvexTestSolver {

    static func isPointInsideConvexPolygon(point: FixVec, polygon: [FixVec]) -> Bool {
        let n = polygon.count

        let p0 = polygon[0]

        if Self.orientation(a: p0, b: polygon[1], c: point) < 0 {
            return false
        }

        var low = 1
        var high = n - 1

        while high - low > 1 {
            let mid = (low + high) / 2
            if Self.orientation(a: p0, b: polygon[mid], c: point) < 0 {
                high = mid
            } else {
                low = mid
            }
        }

        return Self.isTraingleContain(a: p0, b: polygon[low], c: polygon[high], p: point)
    }
    
    private static func orientation(a: FixVec, b: FixVec, c: FixVec) -> Int64 {
        (b.y - a.y) * (c.x - b.x) - (b.x - a.x) * (c.y - b.y)
    }
    
    private static func isTraingleContain(a: FixVec, b: FixVec, c: FixVec, p: FixVec) -> Bool {
        let s0 = Self.orientation(a: a, b: b, c: p)
        let s1 = Self.orientation(a: b, b: c, c: p)
        let s2 = Self.orientation(a: c, b: a, c: p)
        
        return s0 >= 0 && s1 >= 0 && s2 >= 0
    }
    
}


public extension Array where Element == FixVec {
    
    func isContain(point p: FixVec) -> Bool {
        let n = self.count
        var isContain = false
        var b = self[n - 1]
        for i in 0..<n {
            let a = self[i]
            
            let isInRange = (a.y > p.y) != (b.y > p.y)
            if isInRange {
                let dx = b.x - a.x
                let dy = b.y - a.y
                let sx = (p.y - a.y) * dx / dy + a.x
                if p.x < sx {
                    isContain = !isContain
                }
            }
            b = a
        }
        
        return isContain
    }

}
