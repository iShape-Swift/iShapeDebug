//
//  TriangulationSpace+View.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 18.03.2023.
//

import SwiftUI

struct TriangulationSpaceView: View {

    @ObservedObject
    var space: TriangulationSpace
    
    var body: some View {
        GeometryReader { proxy in
            content(size: proxy.size)
        }
    }
    
    private func content(size: CGSize) -> some View {
        space.initSize(screenSize: size)
        return ZStack {
            Color.white
            Path { path in
                for edge in space.edges {
                    path.move(to: edge.a)
                    path.addLine(to: edge.b)
                }
            }.strokedPath(.init(lineWidth: 1)).foregroundColor(.gray)
            space.editor.makeView()
        }.onAppear() {
            space.onAppear()
        }
    }
}
