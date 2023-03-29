//
//  ShapeEditor.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 14.03.2023.
//

import SwiftUI
import iShape
import Combine

final class ShapeEditor: ObservableObject {
   
    var matrix: Matrix = .empty {
        didSet {
            for editor in editors {
                editor.matrix = matrix
            }
        }
    }

    var onUpdate: ((iShape.Shape) -> ())?
    
    private (set) var shape: iShape.Shape = .empty
    private (set) var editors = [ContourEditor]()

    func set(shape: iShape.Shape) {
        self.shape = shape
        editors.removeAll()
        
        let hullEditor = ContourEditor(id: 0, points: .init(shape.contour)) { [weak self] points in
            self?.update(id: 0, points: points)
        }
        
        editors.append(hullEditor)
        
        var id = 1
        for hole in shape.holes {
            let holeEditor = ContourEditor(id: id, points: .init(hole)) { [weak self, anId = id] points in
                self?.update(id: anId, points: points)
            }
            editors.append(holeEditor)
            id += 1
        }
        
        self.onUpdate?(shape)
        self.objectWillChange.send()
    }

    func makeView() -> ShapeEditorView {
        ShapeEditorView(editor: self)
    }
    
    
    private func update(id: Int, points: [CGPoint]) {
        if id == 0 {
            shape.contour = Contour(points)
        } else {
            shape.holes[id - 1] = Contour(points)
        }
        
        onUpdate?(shape)
    }
    
}
