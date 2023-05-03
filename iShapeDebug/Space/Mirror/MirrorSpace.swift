//
//  MirrorSpace.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 20.04.2023.
//

import SwiftUI
import iSpace

final class MirrorSpace: ObservableObject {

    var angle: Float = 0 {
        didSet {
            update()
        }
    }
    
    @Published
    private (set) var ax: Vector = .empty
    
    @Published
    private (set) var bx: Vector = .empty

    @Published
    private (set) var normal: Vector = .empty
    
    @Published
    private (set) var line: [CGPoint] = []
    
    let editor: PointsEditor
    private var matrix: Matrix = .empty
    private var points: [CGPoint] = [
        CGPoint(x: 0, y: 0),
        CGPoint(x: 10, y: -20)
    ]

    init() {
        editor = PointsEditor(points: points)
        editor.onUpdate = { [weak self] points in
            guard let self = self else { return }
            self.points = points
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
        }
    }

    func makeView() -> MirrorSpaceView {
        MirrorSpaceView(space: self)
    }
    
    func onUpdateMatrix() {
        editor.matrix = matrix
        self.update()
    }
    
    private func update() {
        let pX = points[0]
        let pA = points[1]
        
        
        let cs = CGFloat(cos(angle * .pi / 180))
        let sn = CGFloat(sin(angle * .pi / 180))
        let lineA = 50 * CGPoint(x: cs, y: sn) + pX
        let lineB = -50 * CGPoint(x: cs, y: sn) + pX
        self.line = matrix.screen(wordPoints: [lineA, lineB])

        let pN = CGPoint(x: sn, y: -cs)

        
        let x = Vec(Float(pX.x), Float(pX.y))
        let n = Vec(Float(pN.x), Float(pN.y))

        let a = Vec(Float(pA.x), Float(pA.y))
        
        let va = x - a
        let vb = va.mirror(n).vec
        
        let pB = CGPoint(x: CGFloat(vb.x), y: CGFloat(vb.y)) + pX

        let v0 = matrix.screen(wordPoints: [pA, pX])
        let v1 = matrix.screen(wordPoints: [pX, pB])
        let vN = matrix.screen(wordPoints: [pX, 20 * pN + pX])

        self.ax = Vector(id: 0, a: v0[0], b: v0[1])
        self.bx = Vector(id: 0, a: v1[0], b: v1[1])
        
        self.normal = Vector(id: 2, a: vN[0], b: vN[1])
    }
}
