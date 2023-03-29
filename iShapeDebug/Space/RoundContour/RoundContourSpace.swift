//
//  RoundContourSpace.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 22.03.2023.
//

import SwiftUI
import iShape

final class RoundContourSpace: ObservableObject {

    var offset: Float = 2 {
        didSet {
            update(iContour: self.iContour)
        }
    }
    
    var radius: Float = 2 {
        didSet {
            update(iContour: self.iContour)
        }
    }
    
    var ratio: Float = 0.2 {
        didSet {
            update(iContour: self.iContour)
        }
    }

    
    let editor: ContourEditor
    private var matrix: Matrix = .empty
    private var iContour: IntContour = Space.classic.int([
        Point(x: -20, y: -20),
        Point(x: -20, y:  20),
        Point(x:  20, y:  20),
        Point(x:  20, y: -20)
    ])
    
    @Published
    private (set) var roundPoints: [CGPoint] = []
    
    @Published
    private (set) var centerPoint: CGPoint = .zero
    
    init() {
        let points = [CGPoint](Space.classic.float(iContour))
        editor = ContourEditor(id: 0, points: points)
        editor.onUpdate = { [weak self] points in
            self?.update(iContour: Contour(points).int(.classic))
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
            self.update(iContour: self.iContour)
        }
    }
    
    func makeView() -> RoundContourSpaceView {
        RoundContourSpaceView(space: self)
    }
    
    func onUpdateMatrix() {
        editor.matrix = matrix
        self.update(iContour: self.iContour)
    }
    
    private func update(iContour: IntContour) {
        self.iContour = iContour
        let contour = iContour.float(.classic).offset(offset).round(radius: radius, ratio: ratio)
        let points = [CGPoint](contour)
        roundPoints = matrix.screen(wordPoints: points)

        centerPoint = matrix.screen(wordPoint: CGPoint(contour.centroid())) - CGPoint(x: 4, y: 4)
    }
}
