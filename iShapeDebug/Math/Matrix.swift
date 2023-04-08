//
//  Matrix.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 13.03.2023.
//

import CoreGraphics
import simd

struct Matrix {
    
    static let empty = Matrix(screenSize: .zero, toWorld: simd_float3x3.init(0), toScreen: simd_float3x3.init(0))
    
    let screenSize: CGSize
    let toWorld: simd_float3x3
    let toScreen: simd_float3x3
    
    init(screenSize: CGSize, toWorld: simd_float3x3, toScreen: simd_float3x3) {
        self.screenSize = screenSize
        self.toWorld = toWorld
        self.toScreen = toScreen
    }
    
    init(screenSize: CGSize, scale: Float) {
        self.screenSize = screenSize
                
        let sx = scale
        let sy = scale
        
        let dx = Float(0.5 * Float(screenSize.width))
        let dy = Float(0.5 * Float(screenSize.height))
        
        toScreen = simd_float3x3([
            simd_float3(sx, 0, 0),
            simd_float3(0, -sy, 0),
            simd_float3(dx, dy, 1)
        ])
        
        toWorld = toScreen.inverse
    }

    
    @inlinable
    func screen(word l: CGFloat) -> CGFloat {
        CGFloat(toScreen.columns.0.x) * l
    }
    
    @inlinable
    func screen(wordPoint p: CGPoint) -> CGPoint {
        let v = simd_float3(Float(p.x), Float(p.y), 1)
        let r = toScreen * v
        return CGPoint(x: CGFloat(r.x), y: CGFloat(r.y))
    }
    
    @inlinable
    func screen(wordPoints points: [CGPoint]) -> [CGPoint] {
        var result = [CGPoint](repeating: .zero, count: points.count)
        for i in 0..<points.count {
            result[i] = screen(wordPoint: points[i])
        }
        return result
    }
    
    @inlinable
    func world(screenPoint p: CGPoint) -> CGPoint {
        let v = simd_float3(Float(p.x), Float(p.y), 1)
        let r = toWorld * v
        return CGPoint(x: CGFloat(r.x), y: CGFloat(r.y))
    }

    @inlinable
    func world(screenVector s: CGPoint) -> CGPoint {
        let v = simd_float3(Float(s.x), Float(s.y), 0)
        let r = toWorld * v
        return CGPoint(x: CGFloat(r.x), y: CGFloat(r.y))
    }
    
    @inlinable
    func world(screenPoints points: [CGPoint]) -> [CGPoint] {
        var result = [CGPoint](repeating: .zero, count: points.count)
        for i in 0..<points.count {
            result[i] = world(screenPoint: points[i])
        }
        return result
    }
}
