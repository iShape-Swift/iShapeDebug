//
//  TriangulationSpace.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 14.03.2023.
//

import SwiftUI


struct TriangulationSpace: View {
    
    @StateObject
    var viewModel = ViewModel()
    
    var body: some View {
        GeometryReader { proxy in
            content(size: proxy.size)
        }
    }
    
    private func content(size: CGSize) -> some View {
        viewModel.initSize(screenSize: size)
        return ZStack {
            Color.white
            viewModel.editor.makeView()
        }.onAppear() {
            viewModel.onAppear()
        }
    }
}
