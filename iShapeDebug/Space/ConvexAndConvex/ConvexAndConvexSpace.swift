//
//  ConvexAndConvexSpace.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 28.04.2023.
//

import SwiftUI
import iFixFloat
@testable import iFixBox

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

    var posAy: Float = 10 {
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

    var posBy: Float = -10 {
        didSet {
            update()
        }
    }
    
    private var matrix: Matrix = .empty

    
    private var aPoly: [CGPoint] = [
        CGPoint(x: -10, y: -10),
        CGPoint(x: -10, y:  10),
        CGPoint(x:  10, y:  10),
        CGPoint(x:  10, y: -10)
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

        let wA = tA.convertAsPoints(convexA.points)
        let nmsA = tA.convertAsVectors(convexA.normals)
        let rA = tA.convert(convexA.boundary).points()
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
        
        let wB = tB.convertAsPoints(convexB.points)
        let nmsB = tB.convertAsVectors(convexB.normals)
        let rB = tB.convert(convexB.boundary).points()
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

        let solver = CollisionSolver()
        let contact = solver.collide(convexA, convexB, tA: tA, tB: tB)

        let contacts = [contact]
        
        vertices.removeAll()

        var mi = 0
        if contacts.count > 1 {
            for i in 1..<contacts.count {
                if contacts[i].penetration < contacts[i - 1].penetration {
                    mi = i
                }
            }
        }
        
        for i in 0..<contacts.count {
            let contact = contacts[i]
            let cp = matrix.screen(wordPoint: contact.point.cgFloat)
            let cn = matrix.screen(wordPoint: contact.point.cgFloat + 10 * contact.normal.cgFloat)

            let color: Color = mi == i ? .red : .red.opacity(0.2)
            
            let normal = Vector(
                id: normals.count,
                a: cp,
                b: cn,
                stroke: 4,
                color: color
            )
            self.vertices.append(cp)
            self.normals.append(normal)
        }
    }
}

extension Boundary {

    func points() -> [FixVec] {
        [
            min,
            FixVec(min.x, max.y),
            max,
            FixVec(max.x, min.y)
        ]
    }

}

