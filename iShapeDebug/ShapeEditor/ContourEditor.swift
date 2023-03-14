//
//  ContourEditor.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 13.03.2023.
//

import SwiftUI

final class ContourEditor: ObservableObject, Identifiable {

    struct Dot: Identifiable {
        
        static let empty = Dot(id: 0, center: .zero, radius: .zero, color: .gray)
        
        let id: Int
        let center: CGPoint
        let radius: CGFloat
        let color: Color

    }

    var matrix: Matrix = .empty {
        didSet {
            screenPoints = matrix.screen(wordPoints: points)
            objectWillChange.send()
        }
    }
    
    let id: Int
    
    @Published
    private (set) var points: [CGPoint] = []
    private (set) var screenPoints: [CGPoint] = []
    
    private var selectedId = -1
    private var selectedStart: CGPoint = .zero

    init(id: Int, points: [CGPoint]) {
        self.id = id
        self.points = points
    }
    
    var dots: [Dot] {
        var buffer = [Dot](repeating: .empty, count: screenPoints.count)
        
        for i in 0..<screenPoints.count {
            let color: Color = selectedId == i ? .red : .gray
            let radius: CGFloat = selectedId == i ? 12 : 4
            buffer[i] = Dot(id: i, center: screenPoints[i] - CGPoint(x: radius, y: radius), radius: radius, color: color)
        }

        return buffer
    }
    
    func makeView() -> ContourEditorView {
        ContourEditorView(editor: self)
    }
    
    func onDrag(id: Int, move: CGSize) {
        if selectedId == -1 {
            selectedId = id
            selectedStart = points[id]
        }

        points[id] = selectedStart + matrix.world(screenVector: CGPoint(x: move.width, y: move.height))
        screenPoints = matrix.screen(wordPoints: points)
        objectWillChange.send()
    }

    func onEnd(id: Int, move: CGSize) {
        selectedId = -1

        points[id] = selectedStart + matrix.world(screenVector: CGPoint(x: move.width, y: move.height))
        screenPoints = matrix.screen(wordPoints: points)
        objectWillChange.send()
    }
}
