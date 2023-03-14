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
            editor.hullEditor.makeView()
            ForEach(editor.holeEditors) { hole in
                hole.makeView()
            }
        }
    }
    
}
