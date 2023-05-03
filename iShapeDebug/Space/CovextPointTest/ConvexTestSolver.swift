//
//  ConvexTestSolver.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 03.05.2023.
//

import iSpace

public struct ConvexTestSolver {

    /*
     FixVec is a struct {
        let x: Int64
        let y: Int64
     }
     */
    /*
    static func isPointInsideConvexPolygon(point p: FixVec, polygon: [FixVec]) -> Bool {
        let n = polygon.count

        if n < 3 {
            return false
        }

        var low = 1
        var high = n - 1

        print("start")
        let f = polygon[0]
        let fp = f - p
        
        while high - low > 1 {
            let mid = (low + high) / 2
            let m = polygon[mid]
            let pm = p - m
            let orto = pm.crossProduct(fp)
            print(orto)
            let orient = orto < 0
            
            if orient {
                high = mid
                print("high to: \(mid)")
            } else {
                low = mid
                print("low to: \(mid)")
            }
            
            print("low: \(low) hight: \(high)")
        }

        let original = ConvexTestSolver.orientation(a: polygon[low], b: polygon[high], c: f)
        let lastOrient = ConvexTestSolver.orientation(a: polygon[low], b: polygon[high], c: p)
        
        return abs(lastOrient) > abs(original)
    }
    
    */
    
    static func isPointInsideConvexPolygon(point: FixVec, polygon: [FixVec]) -> Bool {
        let n = polygon.count

        if n < 3 {
            return false
        }

        if Self.orientation(a: polygon[0], b: polygon[1], c: point) < 0 {
            return false
        }

        var low = 1
        var high = n - 1

        while high - low > 1 {
            let mid = (low + high) / 2
            if Self.orientation(a: polygon[0], b: polygon[mid], c: point) < 0 {
                high = mid
            } else {
                low = mid
            }
            print("low: \(low) hight: \(high)")
        }
        
        let last = Self.orientation(a: polygon[low], b: polygon[high], c: point)
        print("last: \(last) hight: \(high)")

        return last >= 0
    }
    
    private static func orientation(a: FixVec, b: FixVec, c: FixVec) -> Int64 {
        (b.y - a.y) * (c.x - b.x) - (b.x - a.x) * (c.y - b.y)
    }
    
}


