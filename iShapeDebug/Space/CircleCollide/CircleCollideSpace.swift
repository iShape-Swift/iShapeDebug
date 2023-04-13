//
//  CircleCollideSpace.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 10.04.2023.
//

import SwiftUI
import iSpace
import iNetBox

final class CircleCollideSpace: ObservableObject {

    let dotEditor: PointsEditor
    
    private var matrix: Matrix = .empty

    private var circleRadiusA: CGFloat = 10
    private var circleCenterA = CGPoint(x: 10, y: 10)
    
    private var circleRadiusB: CGFloat = 20
    private var circleCenterB = CGPoint(x: -10, y: -5)
    
    
    @Published
    private (set) var ciCenterA: CGPoint = .zero
    
    @Published
    private (set) var ciRadiusA: CGFloat = 0
    
    @Published
    private (set) var ciCenterB: CGPoint = .zero
    
    @Published
    private (set) var ciRadiusB: CGFloat = 0
    
    @Published
    private (set) var contact: CGPoint?
    
    @Published
    private (set) var normal: Vector?
    
    init() {
        dotEditor = PointsEditor(points: [circleCenterA, circleCenterB])

        dotEditor.onUpdate = { [weak self] points in
            guard let self = self else { return }
            self.circleCenterA = points[0]
            self.circleCenterB = points[1]
            self.update()
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
            self.update()
        }
    }
    
    func makeView() -> CircleCollideSpaceView {
        CircleCollideSpaceView(space: self)
    }
    
    func onUpdateMatrix() {
        dotEditor.matrix = matrix
        self.update()
    }
    
    private func update() {
        ciRadiusA = matrix.screen(word: circleRadiusA)
        ciCenterA = matrix.screen(wordPoint: circleCenterA) - CGPoint(x: ciRadiusA, y: ciRadiusA)

        ciRadiusB = matrix.screen(word: circleRadiusB)
        ciCenterB = matrix.screen(wordPoint: circleCenterB) - CGPoint(x: ciRadiusB, y: ciRadiusB)

        let colliderA = CircleCollider(center: circleCenterA.fix, radius: circleRadiusA.fix)
        let colliderB = CircleCollider(center: circleCenterB.fix, radius: circleRadiusB.fix)
        
        let fixContact = colliderA.collide(circle: colliderB)
        
        if fixContact.type == .outside {
            contact = nil
            normal = nil
        } else {
            contact = matrix.screen(wordPoint: fixContact.point.cgFloat) - CGPoint(x: 4, y: 4)
            normal = Vector(
                id: 0,
                a: matrix.screen(wordPoint: fixContact.point.cgFloat),
                b: matrix.screen(wordPoint: (fixContact.point + 5000 * fixContact.normalA).cgFloat)
            )

        }
    }
}
