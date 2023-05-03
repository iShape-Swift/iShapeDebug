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
    case convexPointTest
    case convexAndConvex
    case convexAndCircle
    case circleCollide
    case split
    case anchor
    case mirror
    
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
        case .convexPointTest:
            return "convexPointTest"
        case .convexAndConvex:
            return "convexAndConvex"
        case .convexAndCircle:
            return "convexAndCircle"
        case .circleCollide:
            return "circleCollide"
        case .split:
            return "split"
        case .anchor:
            return "anchor"
        case .mirror:
            return "mirror"
        }
    }
}
