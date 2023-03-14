//
//  TriangulationData.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 14.03.2023.
//

import iShape

struct TriangulationData {
    
    struct Test {
        let id: Int
        let shape: iShape.Shape
    }
    
    static let data: [Test] = [
        Test(id: 0, shape: Shape(contour: [
            Point(x: -10, y: -10),
            Point(x: -10, y: 10),
            Point(x: 10, y: 10),
            Point(x: 10, y: -10)
        ])),
        Test(id: 1, shape: Shape(contour: [
            Point(x: -20, y: -20),
            Point(x: -10, y: 20),
            Point(x: 20, y: 20),
            Point(x: 20, y: -20)
        ], holes: [
            [
                Point(x: -10, y: 10),
                Point(x: -10, y: -10),
                Point(x: 10, y: -10),
                Point(x: 10, y: 10)
            ]
        ]))
    ].sorted(by:  { $0.id < $1.id })
    
}
