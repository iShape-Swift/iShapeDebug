//
//  ContourEditorView.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 13.03.2023.
//

import SwiftUI

struct ContourEditorView: View {

    @ObservedObject
    var editor: ContourEditor
    
    var body: some View {
        let dots = editor.dots
        return ZStack() {
            Path { path in
                path.addLines(editor.screenPoints)
                path.closeSubpath()
            }.strokedPath(.init(lineWidth: 2)).foregroundColor(.gray)
            ForEach(dots) { dot in
                Circle()
                    .size(width: 2 * dot.radius, height: 2 * dot.radius)
                    .offset(dot.center)
                    .foregroundColor(dot.color)
            }
            ForEach(dots) { dot in
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
            }

        }
    }
    
}
