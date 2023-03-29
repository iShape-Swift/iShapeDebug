//
//  ShapeEditorView.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 14.03.2023.
//

import SwiftUI

struct ShapeEditorView: View {
    
    @ObservedObject
    var editor: ShapeEditor
    
    var body: some View {
        ZStack() {
            ForEach(editor.editors) { contour in
                contour.makeView()
            }
        }
    }
    
}
