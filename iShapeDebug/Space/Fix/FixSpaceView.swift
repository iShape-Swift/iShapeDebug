//
//  FixSpaceView.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 17.03.2023.
//

import SwiftUI

struct FixSpaceView: View {
    
    @ObservedObject
    var space: FixSpace
    
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
            
            ForEach(space.shapes) { shape in
                Path { path in
                    path.addLines(shape.points)
                    path.closeSubpath()
                }.strokedPath(.init(lineWidth: 4)).foregroundColor(shape.color)
            }
            
            VStack {
                space.testNavigator.makeView()
                Spacer()
            }
        }.onAppear() {
            space.onAppear()
        }
    }
}
