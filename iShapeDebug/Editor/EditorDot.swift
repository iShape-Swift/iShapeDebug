//
//  EditorDot.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 21.03.2023.
//

import SwiftUI

struct EditorDot: Identifiable {
    
    static let empty = EditorDot(id: 0, center: .zero, touchCenter: .zero, radius: .zero, touchRadius: .zero, color: .gray, touchColor: .white, title: nil)
    
    let id: Int
    let center: CGPoint
    let touchCenter: CGPoint
    let radius: CGFloat
    let touchRadius: CGFloat
    let color: Color
    let touchColor: Color
    let title: String?
}
