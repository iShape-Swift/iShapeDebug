//
//  WorkSpace.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 13.03.2023.
//

import SwiftUI

enum WorkSpace: Int, Identifiable {

    var id: WorkSpace { self }
    
    case fix
    case tringulation
    case tesselation
    case corner
    case roundContour
    case convex
    case split
    case anchor
    
    var title: String {
        switch self {
        case .fix:
            return "fix"
        case .tringulation:
            return "tringulation"
        case .tesselation:
            return "tesselation"
        case .corner:
            return "corner"
        case .roundContour:
            return "roundContour"
        case .convex:
            return "convex"
        case .split:
            return "split"
        case .anchor:
            return "anchor"
        }
    }
}
