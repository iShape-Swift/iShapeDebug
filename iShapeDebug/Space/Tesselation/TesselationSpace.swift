//
//  TesselationSpace.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 20.03.2023.
//

import SwiftUI
import iShape

final class TesselationSpace: ObservableObject {

    private let tests = TesselationStore.tests
    var maxEdge: Float = 10 {
        didSet {
            update(shape: shape)
        }
    }
    var factor: Float = 1 {
        didSet {
            update(shape: shape)
        }
    }
    
    let editor: ShapeEditor
    let testNavigator: TestNavigator
    private (set) var index = PersistInt(key: "TesselationSpaceIndex", nilValue: 0)
    private var matrix: Matrix = .empty
    private var shape: iShape.Shape = .empty
    
    init() {
        editor = ShapeEditor()
        testNavigator = TestNavigator(index: index.value, count: tests.count)
        editor.onUpdate = { [weak self] shape in
            self?.update(shape: shape)
        }
        
        testNavigator.onUpdate = { [weak self] index in
            self?.update(testIndex: index)
        }
    }
    
    @Published
    private (set) var edges: [Edge] = []
    
    func initSize(screenSize: CGSize) {
        guard !matrix.screenSize.isIntSame(screenSize) else {
            return
        }
        matrix = Matrix(screenSize: screenSize, scale: 10)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.onUpdateMatrix()
            self.update(shape: self.shape)
        }
    }

    func makeView() -> TesselationSpaceView {
        TesselationSpaceView(space: self)
    }
    
    func onAppear() {
        if self.shape.contour.isEmpty {
            self.update(testIndex: testNavigator.index)
        }
    }
    
    func onUpdateMatrix() {
        editor.matrix = matrix
    }
    
    private func update(shape: iShape.Shape) {
        self.shape = shape
        let intShape = shape.int(.classic)

        let delaunay = intShape.split(maxEdge: maxEdge, factor: factor, space: .classic)
        let indices = delaunay.trianglesIndices
        let wordPoints = [CGPoint](delaunay.points.float(.classic))

        let screenPoints = matrix.screen(wordPoints: wordPoints)


        var idSet = Set<EdgeKey>()
        
        var result = [Edge]()
        
        let n = indices.count / 3
        
        var i = 0
        for _ in 0..<n {
            let ia = indices[i]
            let ib = indices[i + 1]
            let ic = indices[i + 2]
            
            let a = screenPoints[ia]
            let b = screenPoints[ib]
            let c = screenPoints[ic]

            let ab = EdgeKey(a: a, b: b)
            if !idSet.contains(ab) {
                idSet.insert(ab)
                result.append(Edge(id: result.count, a: a, b: b, color: .gray))
            }
            
            let bc = EdgeKey(a: b, b: c)
            if !idSet.contains(bc) {
                idSet.insert(bc)
                result.append(Edge(id: result.count, a: b, b: c, color: .gray))
            }
            
            let ca = EdgeKey(a: c, b: a)
            if !idSet.contains(ca) {
                idSet.insert(ca)
                result.append(Edge(id: result.count, a: c, b: a, color: .gray))
            }

            i += 3
        }
        
        self.edges = result
    }
    
    private func update(testIndex: Int) {
        index.value = testIndex
        self.shape = tests[testIndex].shape.float(.classic)
        editor.set(shape: shape)
    }
    
}
