//
//  ConvexAndCircleSpaceView.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 09.04.2023.
//

import SwiftUI

struct ConvexAndCircleSpaceView: View {
    
    @ObservedObject
    var space: ConvexAndCircleSpace
    
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
            space.dotEditor.makeView()
            
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
            
            if space.ciRadius > 0 {
                Circle()
                    .size(width: 2 * space.ciRadius, height: 2 * space.ciRadius)
                    .offset(space.ciCenter)
                    .stroke(lineWidth: 1).foregroundColor(.green)
            }

            Circle()
                .size(width: 8, height: 8)
                .offset(space.center)
                .foregroundColor(.red)
            
            Circle()
                .size(width: 8, height: 8)
                .offset(space.contact)
                .foregroundColor(.red)

        }
    }
}
