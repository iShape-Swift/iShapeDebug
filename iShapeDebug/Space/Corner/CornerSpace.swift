//
//  CornerSpace.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 21.03.2023.
//

import SwiftUI
import iShape

final class CornerSpace: ObservableObject {
    
    var maxRadius: Float = 80
    
    let editor: PointsEditor
    private var matrix: Matrix = .empty
    private var points: [CGPoint] = [
        CGPoint(x: 0, y: 10),
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
    private (set) var roundPoints: [CGPoint] = []
    
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

    func makeView() -> CornerSpaceView {
        CornerSpaceView(space: self)
    }
    
    func onUpdateMatrix() {
        editor.matrix = matrix
        self.update(points: self.points)
    }
    
    private func update(points: [CGPoint]) {
        let screenPoints = matrix.screen(wordPoints: points)

        var result = [Vector]()
        
        result.append(Vector(id: 0, a: screenPoints[1], b: screenPoints[0]))
        result.append(Vector(id: 1, a: screenPoints[1], b: screenPoints[2]))
        
        let dotRadius: Float = 8
        
        let a = Point(screenPoints[0])
        let b = Point(screenPoints[1])
        let c = Point(screenPoints[2])
        
        let p = Morph.cornerCenter(a, b, c, radius: maxRadius)
        let cp = CGPoint(x: CGFloat(p.x - dotRadius), y: CGFloat(p.y - dotRadius))
        
        self.center = Dot(id: 0, center: cp, radius: CGFloat(dotRadius), color: .red)

        let roundPath = Morph.roundCorner(a, b, c, radius: maxRadius, ratio: 0.2)
        
        self.roundPoints = [CGPoint](roundPath)
        self.cornerEdges = result
    }
    
}
