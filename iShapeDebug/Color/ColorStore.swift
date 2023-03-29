//
//  ColorStore.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 18.03.2023.
//

import SwiftUI

final class ColorStore {
    
    static let shared = ColorStore()
    
    let colors: [Color] = [
        Color(hex: "#000080"),
        Color(hex: "#800000"),
        Color(hex: "#008000"),
        Color(hex: "#ffc0cb"),
        Color(hex: "#ffa500"),
        Color(hex: "#a52a2a"),
        Color(hex: "#800080"),
        Color(hex: "#a52a2a"),
        Color(hex: "#ffd700"),
        Color(hex: "#40e0d0"),
        Color(hex: "#000080"),
        Color(hex: "#800000"),
        Color(hex: "#008080"),
        Color(hex: "#808000"),
        Color(hex: "#008080"),
        Color(hex: "#e6e6fa"),
        Color(hex: "#ff7f50"),
        Color(hex: "#f5f5dc"),
        Color(hex: "#ff00ff"),
        Color(hex: "#87ceeb"),
        Color(hex: "#228b22"),
        Color(hex: "#d2691e"),
        Color(hex: "#fa8072"),
        Color(hex: "#f0e68c"),
        Color(hex: "#ffff00"),
        Color(hex: "#4b0082"),
        Color(hex: "#e0b0ff"),
        Color(hex: "#ff0000"),
        Color(hex: "#0000ff")
    ]

    func color(index: Int) -> Color {
        let i = index % colors.count
        return colors[i]
    }
    
}
