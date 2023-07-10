//
//  EdgeTestStore.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 10.07.2023.
//

import iDebug
import CoreGraphics

struct EdgeTest {
    let name: String
    let edgeA: [CGPoint]
    let edgeB: [CGPoint]
}

final class EdgeTestStore: TestStore {
    
    private (set) var pIndex = PersistInt(key: String(describing: EdgeTestStore.self), nilValue: 0)
    
    var onUpdate: (() -> ())?
    
    var tests: [TestHandler] {
        var result = [TestHandler]()
        result.reserveCapacity(data.count)
        
        for i in 0..<data.count {
            result.append(.init(id: i, title: data[i].name))
        }
        
        return result
    }
    
    var testId: Int {
        get {
            pIndex.value
        }
        
        set {
            pIndex.value = newValue
            self.onUpdate?()
        }
    }
    
    var test: EdgeTest {
        data[testId]
    }
    
    let data: [EdgeTest] = [
        .init(
            name: "Test 1",
            edgeA: [
                CGPoint(x: -10, y: 0),
                CGPoint(x:  10, y: 0)
            ],
            edgeB: [
                CGPoint(x:  0, y: -10),
                CGPoint(x:  0, y:  10)
            ]
        ),
        .init(
            name: "Test 2",
            edgeA: [
                CGPoint(x: -10, y: 0),
                CGPoint(x:  10, y: 0)
            ],
            edgeB: [
                CGPoint(x: -10, y: -10),
                CGPoint(x: -10, y:  10)
            ]
        ),
        .init(
            name: "Test 3",
            edgeA: [
                CGPoint(x: -10, y: -10),
                CGPoint(x:  10, y: -10)
            ],
            edgeB: [
                CGPoint(x: -10, y:  10),
                CGPoint(x:  10, y:  10)
            ]
        ),
        .init(
            name: "Test 4",
            edgeA: [
                CGPoint(x: -10, y: -10),
                CGPoint(x:  10, y: -10)
            ],
            edgeB: [
                CGPoint(x: -10, y: -10),
                CGPoint(x: -10, y:  10)
            ]
        )
    ]
    
}
