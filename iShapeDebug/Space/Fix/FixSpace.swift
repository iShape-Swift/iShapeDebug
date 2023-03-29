//
//  FixSpace+ViewModel.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 17.03.2023.
//

import SwiftUI
import iShape

final class FixSpace: ObservableObject {

    struct ContourShape: Identifiable {
        let id: Int
        let points: [CGPoint]
        let color: Color
    }
    
    private let data = FixStore.tests
    let testNavigator: TestNavigator
    let editor: ContourEditor
    private var matrix: Matrix = .empty
    private var iContour: IntContour = []
    
    private (set) var index = PersistInt(key: "FixSpaceIndex", nilValue: 0)
    
    init() {
        editor = ContourEditor(id: 0, points: [])
        testNavigator = TestNavigator(index: index.value, count: data.count)
        
        editor.onUpdate = { [weak self] points in
            self?.update(iContour: Contour(points).int(.classic))
        }
        
        testNavigator.onUpdate = { [weak self] index in
            self?.update(testIndex: index)
        }
    }
    
    @Published
    private (set) var shapes: [ContourShape] = []
    
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
    
    func makeView() -> FixSpaceView {
        FixSpaceView(space: self)
    }

    func onAppear() {
        if self.iContour.isEmpty {
            self.update(testIndex: testNavigator.index)
        }
    }
    
    func onUpdateMatrix() {
        editor.matrix = matrix
        self.update(iContour: self.iContour)
    }
    
    private func update(iContour: IntContour) {
        self.iContour = iContour
//        let iContours = iContour.fix(clockWise: true)
//        
//        var newShapes = [ContourShape]()
//        
//        var id = 0
//        for iContour in iContours {
//            let wordPoints = [CGPoint](iContour.float(.classic))
//            let screenPoints = matrix.screen(wordPoints: wordPoints)
//            
//            newShapes.append(ContourShape(
//                id: id,
//                points: screenPoints,
//                color: ColorStore.shared.color(index: id))
//            )
//            id += 1
//        }
//        
//        self.shapes = newShapes
    }
    
    private func update(testIndex: Int) {
        index.value = testIndex
        self.iContour = data[testIndex].contour
        let points = [CGPoint](iContour.float(.classic))
        editor.set(points: points)
        self.update(iContour: self.iContour)
    }
}
