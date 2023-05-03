//
//  Main+ViewModel.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 13.03.2023.
//

import SwiftUI

extension MainView {

    final class ViewModel: ObservableObject {

        private let fixSpace = FixSpace()
        private let triangulationSpace = TriangulationSpace()
        private let tesselationSpace = TesselationSpace()
        private let cornerSpace = CornerSpace()
        private let roundContourSpace = RoundContourSpace()
        private let convexSpace = ConvexSpace()
        private let convexPointTestSpace = ConvexPointTestSpace()
        private let convexAndConvexSpace = ConvexAndConvexSpace()
        private let convexAndCircleSpace = ConvexAndCircleSpace()
        private let circleCollideSpace = CircleCollideSpace()
        private let splitSpace = SplitSpace()
        private let anchorSpace = AnchorSpace()
        private let mirrorSpace = MirrorSpace()
        
        var spaces: [WorkSpace] = [.fix, .tringulation, .tesselation, .corner, .roundContour, .convex, .convexPointTest, .convexAndConvex, .convexAndCircle, .circleCollide, .split, .anchor, .mirror]
        private (set) var index = PersistInt(key: "WorkSpaceIndex", nilValue: WorkSpace.fix.rawValue)
        
        
        @Published
        var selection: WorkSpace = .fix {
            didSet {
                index.value = selection.rawValue
            }
        }

        @ViewBuilder var contentView: some View {
            switch selection {
            case .fix:
                fixSpace.makeView()
            case .tringulation:
                triangulationSpace.makeView()
            case .tesselation:
                tesselationSpace.makeView()
            case .corner:
                cornerSpace.makeView()
            case .roundContour:
                roundContourSpace.makeView()
            case .convex:
                convexSpace.makeView()
            case .convexPointTest:
                convexPointTestSpace.makeView()
            case .convexAndConvex:
                convexAndConvexSpace.makeView()
            case .convexAndCircle:
                convexAndCircleSpace.makeView()
            case .circleCollide:
                circleCollideSpace.makeView()
            case .split:
                splitSpace.makeView()
            case .anchor:
                anchorSpace.makeView()
            case .mirror:
                mirrorSpace.makeView()
            }
        }
        
        func onAppear() {
            if index.value != selection.rawValue {
                if let last = WorkSpace(rawValue: index.value) {
                    selection = last
                }
            }
        }
    }
}

