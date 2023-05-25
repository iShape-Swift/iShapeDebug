//
//  ConvexPointTestSpace.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 03.05.2023.
//

import SwiftUI
import iSpace
import iNetBox

final class ConvexPointTestSpace: ObservableObject {
    
    let editor: ContourEditor
    let dotEditor: PointsEditor
    
    private var matrix: Matrix = .empty
    
    
    private var points: [CGPoint] = [
        CGPoint(x: -20, y: -20),
        CGPoint(x: -20, y: 0),
        CGPoint(x: -20, y:  20),
        CGPoint(x:   0, y:  20),
        CGPoint(x:  20, y:  20),
        CGPoint(x:  20, y: -20)
    ]

    private var circleRadius: CGFloat = 10
    private var circleCenter = CGPoint(x: 0, y: 30)
    
    @Published
    private (set) var ciCenter: CGPoint = .zero
    
    @Published
    private (set) var ciRadius: CGFloat = 0
    
    init() {
        editor = ContourEditor(id: 0, points: points)
        dotEditor = PointsEditor(points: [circleCenter])
        
        editor.onUpdate = { [weak self] points in
            guard let self = self else { return }
            self.points = points
            self.update()
        }
        dotEditor.onUpdate = { [weak self] points in
            guard let self = self else { return }
            self.circleCenter = points[0]
            self.update()
        }
    }
    
    func initSize(screenSize: CGSize) {
        guard !matrix.screenSize.isIntSame(screenSize) else {
            return
        }
        matrix = Matrix(screenSize: screenSize, scale: 10)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.onUpdateMatrix()
            self.update()
        }
    }
    
    func makeView() -> ConvexPointTestSpaceView {
        ConvexPointTestSpaceView(space: self)
    }
    
    func onUpdateMatrix() {
        editor.matrix = matrix
        dotEditor.matrix = matrix
        self.update()
    }
    
    private func update() {
        let convex = ConvexCollider(points: points.fix)

        let isContain = ConvexTestSolver.isPointInsideConvexPolygon(point: circleCenter.fix, polygon: convex.points)
//        let isContain = convex.points.isContain(point: circleCenter.fix)
//        let isContain = convex.points.isTraingleContain(point: circleCenter.fix)

        if isContain {
            ciRadius = matrix.screen(word: circleRadius)
        } else {
            ciRadius = 0
        }
                
        ciCenter = matrix.screen(wordPoint: circleCenter) - CGPoint(x: ciRadius, y: ciRadius)
    }
}
