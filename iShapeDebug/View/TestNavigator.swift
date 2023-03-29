//
//  TestNavigator.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 18.03.2023.
//

import SwiftUI

final class TestNavigator: ObservableObject {
 
    private let count: Int
    
    @Published
    private (set) var index: Int
    
    var onUpdate: ((Int) -> ())?
    
    init(index: Int, count: Int) {
        self.index = index
        self.count = count
    }
    
    func makeView() -> TestNavigatorView {
        TestNavigatorView(navigator: self)
    }
    
    func prev() {
        index = (index - 1 + count) % count
        onUpdate?(index)
    }
    
    func next() {
        index = (index + 1) % count
        onUpdate?(index)
    }
    
}
