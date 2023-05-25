//
//  ConvexSpace.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 08.04.2023.
//

import SwiftUI
import iSpace
import iNetBox

final class ConvexSpace: ObservableObject {
    
    let editor: ContourEditor
    private var matrix: Matrix = .empty
    
    
    private var points: [CGPoint] = [
        CGPoint(x: -20, y: -20),
        CGPoint(x: -20, y:   0),
        CGPoint(x: -20, y:  20),
        CGPoint(x:   0, y:  20),
        CGPoint(x:  20, y:  20),
        CGPoint(x:  20, y: -20)
    ]
    
    @Published
    private (set) var center: CGPoint = .zero
    
    @Published
    private (set) var radius: CGFloat = .zero

    @Published
    private (set) var box: [CGPoint] = []
    
    @Published
    private (set) var normals: [Vector] = []
    
    init() {
        editor = ContourEditor(id: 0, points: points)
        editor.onUpdate = { [weak self] points in
            self?.update(points: points)
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
            self.update(points: self.points)
        }
    }
    
    func makeView() -> ConvexSpaceView {
        ConvexSpaceView(space: self)
    }
    
    func onUpdateMatrix() {
        editor.matrix = matrix
        self.update(points: self.points)
    }
    
    private func update(points: [CGPoint]) {
        self.points = points
        
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
        let pMax = convex.box.pMax.cgFloat
        let pMin = convex.box.pMin.cgFloat
        
        box = matrix.screen(wordPoints: [pMin, CGPointMake(pMin.x, pMax.y), pMax, CGPointMake(pMax.x, pMin.y)])

        center = matrix.screen(wordPoint: convex.center.cgFloat) - CGPoint(x: 4, y: 4)
        radius = matrix.screen(word: convex.radius.cgFloat)
        
        self.normals = normals
    }
}
