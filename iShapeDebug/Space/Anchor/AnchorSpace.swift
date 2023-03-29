//
//  AnchorSpace.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 25.03.2023.
//

import SwiftUI
import iShape

final class AnchorSpace: ObservableObject {
    
    var maxRadius: Float = 80
    
    var bL: Float = 100 {
        didSet {
            update(points: points)
        }
    }
    
    var aL: Float = 100 {
        didSet {
            update(points: points)
        }
    }
    
    let editor: PointsEditor
    private var matrix: Matrix = .empty
    private var points: [CGPoint] = [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 10, y: 0)
    ]
    
    init() {
        editor = PointsEditor(points: points)
        editor.onUpdate = { [weak self] points in
            guard let self = self else { return }
            self.points = points
            self.update(points: points)
        }
    }
    
    @Published
    private (set) var cornerEdges: [Vector] = []
    
    @Published
    private (set) var center: Dot = Dot(id: 0, center: .zero, radius: 1, color: .gray)
    
    func initSize(screenSize: CGSize) {
        guard !matrix.screenSize.isIntSame(screenSize) else {
            return
        }
        matrix = Matrix(screenSize: screenSize, scale: 10)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.onUpdateMatrix()
        }
    }

    func makeView() -> AnchorSpaceView {
        AnchorSpaceView(space: self)
    }
    
    func onUpdateMatrix() {
        editor.matrix = matrix
        self.update(points: self.points)
    }
    
    private func update(points: [CGPoint]) {
        let screenPoints = matrix.screen(wordPoints: points)
        
        let dotRadius: Float = 8
        
        let a = Point(screenPoints[0])
        let b = Point(screenPoints[1])

        let p = AnchorSolver.point(a: a, b: b, aL: aL, bL: bL)
        
        
        let cp = CGPoint(x: CGFloat(p.x - dotRadius), y: CGFloat(p.y - dotRadius))
        
        self.center = Dot(id: 0, center: cp, radius: CGFloat(dotRadius), color: .red)
        self.cornerEdges = [Vector(id: 0, a: screenPoints[0], b: screenPoints[1])]
    }
    
}
