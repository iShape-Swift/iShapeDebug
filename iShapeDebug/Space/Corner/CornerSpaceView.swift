//
//  CornerSpaceView.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 21.03.2023.
//

import SwiftUI

struct CornerSpaceView: View {
    
    @ObservedObject
    var space: CornerSpace
    
    var body: some View {
        GeometryReader { proxy in
            content(size: proxy.size)
        }
    }
    
    private func content(size: CGSize) -> some View {
        space.initSize(screenSize: size)
        return ZStack {
            Color.white
            space.editor.makeView()
            
            ForEach(space.cornerEdges) { vector in
                VectorShape(vector: vector)
                    .stroke(lineWidth: 2)
                    .foregroundColor(.green)
            }
            
            Path { path in
                path.addLines(space.roundPoints)
            }.strokedPath(.init(lineWidth: 1)).foregroundColor(.red)
            
            Circle()
                .size(width: 2 * space.center.radius, height: 2 * space.center.radius)
                .offset(space.center.center)
                .foregroundColor(space.center.color)
        }
    }
}
