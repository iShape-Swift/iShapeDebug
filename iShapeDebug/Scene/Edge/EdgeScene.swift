//
//  EdgeScene.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 10.07.2023.
//

import SwiftUI
import iDebug
import iShape
import iFixFloat

struct Edge: Identifiable {
    let id: Int
    let a: CGPoint
    let b: CGPoint
}

final class EdgeScene: ObservableObject, SceneContainer {

    let id: Int
    let title = "Edge"
    let edgeTestStore = EdgeTestStore()
    var testStore: TestStore { edgeTestStore }
    let editor = PointsEditor()
    
    static let colorA: Color = .orange
    static let colorB: Color = .purple

    private (set) var edgeA: Edge?
    private (set) var edgeB: Edge?
    private (set) var crossVec: CGPoint?
    private (set) var crossResult = ""
    
    private (set) var colorA: Color = EdgeScene.colorA
    private (set) var colorB: Color = EdgeScene.colorB
    
    private var matrix: Matrix = .empty
    
    init(id: Int) {
        self.id = id
        edgeTestStore.onUpdate = self.didUpdateTest
        
        editor.onUpdate = { [weak self] _ in
            self?.didUpdateEditor()
        }
    }
    
    func initSize(screenSize: CGSize) {
        if !matrix.screenSize.isIntSame(screenSize) {
            matrix = Matrix(screenSize: screenSize, scale: 10, inverseY: true)
            DispatchQueue.main.async { [weak self] in
                self?.solve()
            }
        }
    }
    
    func makeView() -> EdgeSceneView {
        EdgeSceneView(scene: self)
    }

    func dotsEditorView() -> PointsEditorView {
        editor.makeView(matrix: matrix)
    }
    
    func didUpdateTest() {
        let test = edgeTestStore.test
        
        let points = test.edgeA + test.edgeB
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.editor.set(points: points)
            self.solve()
        }
    }
    
    func didUpdateEditor() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            // TODO validate convex
            self.solve()
        }
    }
    
    func onAppear() {
        didUpdateTest()
    }

    func solve() {
        let points = editor.points
        let vecs = points.map { $0.fixVec }
        guard !vecs.isEmpty else {
            edgeA = nil
            edgeB = nil
            crossResult = ""
            return
        }
        
        let screen = matrix.screen(worldPoints: points)
        
        edgeA = Edge(id: 0, a: screen[0], b: screen[1])
        edgeB = Edge(id: 1, a: screen[2], b: screen[3])

        let edA = FixEdge(e0: vecs[0], e1: vecs[1])
        let edB = FixEdge(e0: vecs[2], e1: vecs[3])
        
        let cross = edA.cross(edB)
        
        switch cross.type {
        case .not_cross:
            crossResult = "not cross or parallel"
        case .pure:
            crossResult = "middle cross : \(cross.point.floatString)"
        case .end_a:
            crossResult = "A end cross : \(cross.point.floatString)"
        case .end_b:
            crossResult = "B end cross : \(cross.point.floatString)"
        case .common_end:
            crossResult = "ends cross : \(cross.point.floatString)"
        }

        if cross.type != .not_cross {
            colorA = EdgeScene.colorA
            colorB = EdgeScene.colorB
            crossVec = matrix.screen(worldPoint: cross.point.cgPoint)
        } else {
            colorA = EdgeScene.colorA.opacity(0.8)
            colorB = EdgeScene.colorB.opacity(0.8)
            crossVec = nil
        }
        
        self.objectWillChange.send()
    }
    
    
    func printTest() {
        let points = editor.points
        let edgeA = [points[0], points[1]]
        let edgeB = [points[2], points[3]]

        print("A: \(edgeA.prettyPrint())")
        print("B: \(edgeB.prettyPrint())")
    }
    
}

private extension FixVec {
    
    var floatString: String {
        let p = self.float
        let x = String(format: "%.2f", p.x)
        let y = String(format: "%.2f", p.y)
        return "(\(x), \(y)"
    }

}
