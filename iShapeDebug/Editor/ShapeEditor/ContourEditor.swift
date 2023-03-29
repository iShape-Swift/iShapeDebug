//
//  ContourEditor.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 13.03.2023.
//

import SwiftUI

final class ContourEditor: ObservableObject, Identifiable {

    var matrix: Matrix = .empty {
        didSet {
            screenPoints = matrix.screen(wordPoints: points)
        }
    }
    
    var onUpdate: (([CGPoint]) -> ())?

    private (set) var points: [CGPoint] = []
    
    @Published
    private (set) var screenPoints: [CGPoint] = []
    
    private var selectedId = -1
    private var selectedStart: CGPoint = .zero
    let id: Int
    
    init(id: Int, points: [CGPoint], onUpdate: (([CGPoint]) -> ())? = nil) {
        self.id = id
        self.points = points
        self.onUpdate = onUpdate
    }
    
    var dots: [EditorDot] {
        var buffer = [EditorDot](repeating: .empty, count: screenPoints.count)
        let radius: CGFloat = 3
        let touchRadius: CGFloat = 22
        for i in 0..<screenPoints.count {
            let center = screenPoints[i] - CGPoint(x: radius, y: radius)
            let touchCenter = screenPoints[i] - CGPoint(x: touchRadius, y: touchRadius)
            let touchColor: Color = selectedId == i ? .black.opacity(0.15) : .black.opacity(0.05)
            
            buffer[i] = EditorDot(id: i, center: center, touchCenter: touchCenter, radius: 4, touchRadius: touchRadius, color: .gray, touchColor: touchColor, title: nil)
        }

        return buffer
    }
    
    func set(points: [CGPoint]) {
        self.points = points
        screenPoints = matrix.screen(wordPoints: points)
    }
    
    func makeView() -> ContourEditorView {
        ContourEditorView(editor: self)
    }
    
    func onDrag(id: Int, move: CGSize) {
        if selectedId == -1 {
            selectedId = id
            selectedStart = points[id]
        }
        update(id: id, move: move)
    }

    func onEnd(id: Int, move: CGSize) {
        selectedId = -1
        update(id: id, move: move)
    }
    
    private func update(id: Int, move: CGSize) {
        let newPoint = selectedStart + matrix.world(screenVector: CGPoint(x: move.width, y: move.height))
        if newPoint != points[id] || selectedId == -1 {
            points[id] = newPoint
            screenPoints = matrix.screen(wordPoints: points)
            onUpdate?(points)
        }
    }
}
