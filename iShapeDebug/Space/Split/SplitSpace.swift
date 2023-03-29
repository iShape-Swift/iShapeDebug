//
//  SplitSpace.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 22.03.2023.
//

import SwiftUI
import iShape

final class SplitSpace: ObservableObject {

    struct ContourShape: Identifiable {
        let id: Int
        let points: [CGPoint]
        let color: Color
    }
    
    @Published
    private (set) var shapes: [ContourShape] = []
    
    private let tests = TesselationStore.tests
    
    var scale: Float = 0.9 {
        didSet {
            update(shape: shape)
        }
    }
    
    var radius: Float = 1 {
        didSet {
            update(shape: shape)
        }
    }
    
    var maxEdge: Float = 10 {
        didSet {
            update(shape: shape)
        }
    }
    var tesFactor: Float = 0.2 {
        didSet {
            update(shape: shape)
        }
    }

    let editor: ShapeEditor
    let testNavigator: TestNavigator
    private (set) var index = PersistInt(key: "SplitSpaceIndex", nilValue: 0)
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

    func makeView() -> SplitSpaceView {
        SplitSpaceView(space: self)
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

        let delaunay = intShape.split(maxEdge: maxEdge, factor: tesFactor, space: .classic)
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
        
        // centroid net
        
        let centroids = delaunay.makeCentroidNet(minArea: 0)
        
        var newShapes = [ContourShape]()
        
        var sId = 0
        for centroid in centroids {
            let path = Space.classic.float(centroid)
            
            let contour = path.scale(scale).round(radius: radius)
            let wPoints = [CGPoint](contour)
            let sPoints = matrix.screen(wordPoints: wPoints)
            newShapes.append(.init(id: sId, points: sPoints, color: .blue))
            sId += 1
        }
        
        shapes = newShapes
    }
    
    private func update(testIndex: Int) {
        index.value = testIndex
        self.shape = tests[testIndex].shape.float(.classic)
        editor.set(shape: shape)
    }
    
}
