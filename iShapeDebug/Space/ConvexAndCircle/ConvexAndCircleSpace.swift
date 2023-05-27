//
//  ConvexAndCircleSpace.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 09.04.2023.
//

import SwiftUI
import iFixFloat
import iFixBox

final class ConvexAndCircleSpace: ObservableObject {
    
    let editor: ContourEditor
    let dotEditor: PointsEditor
    
    private var matrix: Matrix = .empty
    
    
    private var points: [CGPoint] = [
        CGPoint(x: -20, y: -20),
        CGPoint(x: -20, y:   0),
        CGPoint(x: -20, y:  20),
        CGPoint(x:   0, y:  20),
        CGPoint(x:  20, y:  20),
        CGPoint(x:  20, y: -20)
    ]

    private var circleRadius: CGFloat = 10
    private var circleCenter = CGPoint(x: 10, y: 10)
    
    @Published
    private (set) var center: CGPoint = .zero

    @Published
    private (set) var ciCenter: CGPoint = .zero
    
    @Published
    private (set) var ciRadius: CGFloat = 0
    
    @Published
    private (set) var box: [CGPoint] = []
    
    @Published
    private (set) var normals: [Vector] = []
    
    @Published
    private (set) var contact: CGPoint = .zero
    
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
    
    func makeView() -> ConvexAndCircleSpaceView {
        ConvexAndCircleSpaceView(space: self)
    }
    
    func onUpdateMatrix() {
        editor.matrix = matrix
        dotEditor.matrix = matrix
        self.update()
    }
    
    private func update() {
        let convex = ConvexCollider(points: points.fix)
        let n = convex.points.count
        var normals = [Vector](repeating: .empty, count: n)
        for i in 0..<n {
            let p0 = convex.points[i].cgFloat
            let p1 = convex.points[(i + 1) % n].cgFloat
            let nm = convex.normals[i].cgFloat
            let e0 = 0.5 * (p0 + p1)
            let e1 = e0 + 10 * nm
            normals[i] = Vector(id: i, a: matrix.screen(wordPoint: e0), b: matrix.screen(wordPoint: e1))
        }

        center = matrix.screen(wordPoint: convex.center.cgFloat) - CGPoint(x: 4, y: 4)
        
        
        ciRadius = matrix.screen(word: circleRadius)
        ciCenter = matrix.screen(wordPoint: circleCenter) - CGPoint(x: ciRadius, y: ciRadius)
        
        let fixContact = CollisionSolver().collide(CircleCollider(center: circleCenter.fix, radius: circleRadius.fix), convex)

        
        contact = matrix.screen(wordPoint: fixContact.point.cgFloat) - CGPoint(x: 4, y: 4)

        let cNormal = Vector(
            id: normals.count,
            a: matrix.screen(wordPoint: fixContact.point.cgFloat),
            b: matrix.screen(wordPoint: (fixContact.point + 5000 * fixContact.normal).cgFloat)
        )

        normals.append(cNormal)
        self.normals = normals
    }
}
