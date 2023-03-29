//
//  EdgeKey.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 18.03.2023.
//

import CoreGraphics

struct EdgeKey: Hashable {

    private let a: CGPoint
    private let b: CGPoint
    
    init(a: CGPoint, b: CGPoint) {
        if a.x < b.x {
            self.a = a
            self.b = b
        } else if a.x > b.x {
            self.a = b
            self.b = a
        } else if a.y < b.y {
            self.a = a
            self.b = b
        } else {
            self.a = b
            self.b = a
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(a.x * a.y)
        hasher.combine(b.x * b.y)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.a == rhs.a && lhs.b == rhs.b
    }
}
