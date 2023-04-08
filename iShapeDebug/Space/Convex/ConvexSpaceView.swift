//
//  ConvexSpaceView.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 08.04.2023.
//

import SwiftUI

struct ConvexSpaceView: View {
    
    @ObservedObject
    var space: ConvexSpace
    
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
            
            ForEach(space.normals) { vector in
                VectorShape(vector: vector)
                    .stroke(lineWidth: 2)
                    .foregroundColor(.green)
            }
            
            if space.box.count > 3 {
                Path { path in
                    path.addLines(space.box)
                    path.closeSubpath()
                }.stroke(lineWidth: 1).foregroundColor(.blue)
            }

            Circle()
                .size(width: 8, height: 8)
                .offset(space.center)
                .foregroundColor(.red)
        }
    }
}
