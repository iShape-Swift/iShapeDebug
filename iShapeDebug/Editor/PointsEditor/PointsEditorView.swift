//
//  PointsEditorView.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 21.03.2023.
//

import SwiftUI

struct PointsEditorView: View {

    @ObservedObject
    var editor: PointsEditor
    
    var body: some View {
        let dots = editor.dots
        return ZStack() {
            ForEach(dots) { dot in
                Circle()
                    .size(width: 2 * dot.radius, height: 2 * dot.radius)
                    .offset(dot.center)
                    .foregroundColor(dot.color)
            }
            ForEach(dots) { dot in
                ZStack() {
                    Circle()
                        .size(width: 2 * dot.touchRadius, height: 2 * dot.touchRadius)
                        .offset(dot.touchCenter)
                        .foregroundColor(dot.touchColor)
                        .gesture(
                            DragGesture()
                                .onChanged { data in
                                    editor.onDrag(id: dot.id, move: data.translation)
                                }
                                .onEnded { data in
                                    editor.onEnd(id: dot.id, move: data.translation)
                                }
                        )
                    if let title = dot.title {
                        Text(title).position(dot.center + CGPoint(x: -2, y: -10)).foregroundColor(.red)
                    }
                }
            }
        }
    }
    
}
