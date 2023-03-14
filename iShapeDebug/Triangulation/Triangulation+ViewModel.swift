//
//  Triangulation+ViewModel.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 14.03.2023.
//

import SwiftUI

extension TriangulationSpace {
    
    final class ViewModel: ObservableObject {

        private let data = TriangulationData.data
        
        let editor = ShapeEditor()
        private var matrix: Matrix = .empty
        
        func initSize(screenSize: CGSize) {
            guard !matrix.screenSize.isIntSame(screenSize) else {
                return
            }
            matrix = Matrix(screenSize: screenSize, scale: 10)
            DispatchQueue.main.async { [weak self] in
                self?.onUpdateMatrix()
            }
        }

        func onAppear() {
            editor.set(shape: data[1].shape)
            self.objectWillChange.send()
        }
        
        func onUpdateMatrix() {
            editor.matrix = matrix
        }
    }
    
}

