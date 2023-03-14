//
//  CGSize+Compare.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 14.03.2023.
//

import CoreGraphics

extension CGSize {
    
    func isIntSame(_ size: CGSize) -> Bool {
        Int(size.width) == Int(width) && Int(size.height) == Int(height)
    }
    
}
