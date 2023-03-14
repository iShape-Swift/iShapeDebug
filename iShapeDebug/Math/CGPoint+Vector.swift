//
//  CGPoint+Vector.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 13.03.2023.
//

import CoreGraphics

extension CGPoint {
    
    var length: CGFloat {
        return (x * x + y * y).squareRoot()
    }
    
    var magnitude: CGFloat {
        return x * x + y * y
    }
    
    var normalize: CGPoint {
        let l = self.length
        return CGPoint(x: x / l, y: y / l)
    }

}

func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(left: CGFloat, right: CGPoint) -> CGPoint {
    return CGPoint(x: left * right.x, y: left * right.y)
}

func /(left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x / right, y: left.y / right)
}
