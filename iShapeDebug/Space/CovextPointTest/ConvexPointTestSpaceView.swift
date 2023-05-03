//
//  ConvexPointTestSpaceView.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 03.05.2023.
//

import SwiftUI

struct ConvexPointTestSpaceView: View {
    
    @ObservedObject
    var space: ConvexPointTestSpace
    
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
            
            if space.ciRadius > 0 {
                Circle()
                    .size(width: 2 * space.ciRadius, height: 2 * space.ciRadius)
                    .offset(space.ciCenter)
                    .stroke(lineWidth: 4).foregroundColor(.red)
            }
        }
    }
}
