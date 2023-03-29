//
//  TriangulationSpace.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 14.03.2023.
//

import SwiftUI
import iShape

final class TriangulationSpace: ObservableObject {

    private let data = TriangulationData.data
    
    let editor: ShapeEditor
    private var matrix: Matrix = .empty
    private var shape: iShape.Shape = .empty
    
    init() {
        editor = ShapeEditor()
        editor.onUpdate = { [weak self] shape in
            self?.update(shape: shape)
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

    func makeView() -> TriangulationSpaceView {
        TriangulationSpaceView(space: self)
    }
    
    func onAppear() {
        self.shape = data[1].shape
        editor.set(shape: shape)
    }
    
    func onUpdateMatrix() {
        editor.matrix = matrix
    }
    
    private func update(shape: iShape.Shape) {
        let intShape = shape.int(.classic)
        let wordPoints = [CGPoint](shape.points)
        let screenPoints = matrix.screen(wordPoints: wordPoints)
        let indices = intShape.triangulate()

        var idSet = Set<EdgeKey>()
        
        if var b = screenPoints.last {
            for a in screenPoints {
                idSet.insert(EdgeKey(a: a, b: b))
                b = a
            }
        }
        
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
    
}
