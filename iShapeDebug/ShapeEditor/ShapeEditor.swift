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
            hullEditor.matrix = matrix
            for hole in holeEditors {
                hole.matrix = matrix
            }
        }
    }

    @Published
    private (set) var shape: iShape.Shape = .empty
    
    private var subscriptions: [Int: AnyCancellable] = [:]
    
    func set(shape: iShape.Shape) {
        hullEditor = ContourEditor(id: 0, points: .init(shape.contour))
        subscriptions[0] = hullEditor.$points.sink { [weak self] points in
            self?.update(id: 0, points: points)
        }

        holeEditors.removeAll()
        var id = 1
        for hole in shape.holes {
            let holeEditor = ContourEditor(id: id, points: .init(hole))
            holeEditors.append(holeEditor)
            subscriptions[id] = holeEditor.$points.sink { [weak self] points in
                self?.update(id: id, points: points)
            }
            id += 1
        }
        self.objectWillChange.send()
    }
    
    private (set) var hullEditor: ContourEditor = .init(id: 0, points: [])
    private (set) var holeEditors: [ContourEditor] = []

    func makeView() -> ShapeEditorView {
        ShapeEditorView(editor: self)
    }
    
    
    private func update(id: Int, points: [CGPoint]) {
        guard let index = subscriptions.keys.sorted(by: { $0 < $1 }).firstIndex(where: { $0 == id }) else { return }

        if points.count > 2 {
            if index == 0 {
                shape.contour = Contour(points)
            } else {
                shape.holes[index] = Contour(points)
            }
        } else {
            subscriptions[id] = nil
            if index == 0 {
                shape = .empty
            } else {
                shape.holes.remove(at: index)
            }
        }
        
    }
    
}
