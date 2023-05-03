//
//  ConvexAndConvexSpace.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 28.04.2023.
//

import SwiftUI
import iSpace
import iNetBox

final class ConvexAndConvexSpace: ObservableObject {
    
    let aEditor: ContourEditor
    let bEditor: ContourEditor
    
    var angA: Float = 0 {
        didSet {
            update()
        }
    }

    var posAx: Float = 0 {
        didSet {
            update()
        }
    }

    var posAy: Float = 0 {
        didSet {
            update()
        }
    }
    
    var angB: Float = 0 {
        didSet {
            update()
        }
    }

    var posBx: Float = 0 {
        didSet {
            update()
        }
    }

    var posBy: Float = 0 {
        didSet {
            update()
        }
    }
    
    private var matrix: Matrix = .empty

//    private var aPoly: [CGPoint] = [
//        CGPoint(x: -20, y: -15),
//        CGPoint(x: -20, y:  15),
//        CGPoint(x:   0, y:  20),
//        CGPoint(x:  20, y:  15),
//        CGPoint(x:  20, y: -15),
//        CGPoint(x:   0, y: -20)
//    ]
    
    private var aPoly: [CGPoint] = [
        CGPoint(x: -15, y: -15),
        CGPoint(x: -15, y:  15),
        CGPoint(x:  15, y:  15),
        CGPoint(x:  15, y: -15)
    ]
    
    private var bPoly: [CGPoint] = [
        CGPoint(x: -10, y: -10),
        CGPoint(x: -10, y:  10),
        CGPoint(x:  10, y:  10),
        CGPoint(x:  10, y: -10)
    ]
    
    @Published
    private (set) var normals: [Vector] = []

    @Published
    private (set) var moveA: [CGPoint] = []
    
    @Published
    private (set) var moveB: [CGPoint] = []
    
    @Published
    private (set) var rectA: [CGPoint] = []
    
    @Published
    private (set) var rectB: [CGPoint] = []
    
    @Published
    private (set) var vertices: [CGPoint] = []

    @Published
    private (set) var isIntersect: Bool = false
    
    init() {
        aEditor = ContourEditor(id: 0, points: aPoly)
        bEditor = ContourEditor(id: 1, points: bPoly)

        aEditor.onUpdate = { [weak self] points in
            guard let self = self else { return }
            self.aPoly = points
            self.update()
        }
        bEditor.onUpdate = { [weak self] points in
            guard let self = self else { return }
            self.bPoly = points
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
    
    func makeView() -> ConvexAndConvexSpaceView {
        ConvexAndConvexSpaceView(space: self)
    }
    
    func onUpdateMatrix() {
        aEditor.matrix = matrix
        bEditor.matrix = matrix
        self.update()
    }
    
    private func update() {
        
        // A
        
        let convexA = ConvexCollider(points: aPoly.fix)

        let pA = FixVec(posAx.fix, posAy.fix)
        let aA = (angA / 180 * .pi).fix
        let tA = Transform(position: pA, angle: aA)
        
        // B
        
        let convexB = ConvexCollider(points: bPoly.fix)

        let pB = FixVec(posBx.fix, posBy.fix)
        let aB = (angB / 180 * .pi).fix
        let tB = Transform(position: pB, angle: aB)

        // to world A

        let wA = tA.convert(points: convexA.points)
        let nmsA = tA.convert(vectors: convexA.normals)
        let rA = tA.convert(boundary: convexA.box).points()
        moveA = matrix.screen(wordPoints: wA.cgFloat)
        rectA = matrix.screen(wordPoints: rA.cgFloat)
        
        let nA = convexA.points.count
        var normalsA = [Vector](repeating: .empty, count: nA)
        for i in 0..<nA {
            let p0 = wA[i].cgFloat
            let p1 = wA[(i + 1) % nA].cgFloat
            let nm = nmsA[i].cgFloat
            let e0 = 0.5 * (p0 + p1)
            let e1 = e0 + 10 * nm

            normalsA[i] = Vector(id: i, a: matrix.screen(wordPoint: e0), b: matrix.screen(wordPoint: e1))
        }
        
        // to world B
        
        let wB = tB.convert(points: convexB.points)
        let nmsB = tB.convert(vectors: convexB.normals)
        let rB = tB.convert(boundary: convexB.box).points()
        moveB = matrix.screen(wordPoints: wB.cgFloat)
        rectB = matrix.screen(wordPoints: rB.cgFloat)
        
        
        let nB = convexB.points.count
        var normalsB = [Vector](repeating: .empty, count: nB)
        for i in 0..<nB {
            let p0 = wB[i].cgFloat
            let p1 = wB[(i + 1) % nB].cgFloat
            let nm = nmsB[i].cgFloat
            let e0 = 0.5 * (p0 + p1)
            let e1 = e0 + 10 * nm
           
            normalsB[i] = Vector(id: nA + i, a: matrix.screen(wordPoint: e0), b: matrix.screen(wordPoint: e1))
        }

        self.normals = normalsA + normalsB

        let contact = ColliderSolver.collide(a: convexA, b: convexB, tA: tA, tB: tB)
        vertices.removeAll()

        
            let cp = matrix.screen(wordPoint: contact.point.cgFloat)
            let cn = matrix.screen(wordPoint: contact.point.cgFloat + 10 * contact.normal.cgFloat)

            let normal = Vector(
                id: normals.count,
                a: cp,
                b: cn,
                stroke: 4,
                color: .red
            )
            self.vertices.append(cp)
            self.normals.append(normal)

        
    }
}
