//
//  AreaSceneView.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 10.07.2023.
//

import SwiftUI

struct AreaSceneView: View {
 
    @ObservedObject
    var scene: AreaScene
    
    var body: some View {
        return HStack {
            GeometryReader { proxy in
                content(size: proxy.size)
            }
        }
    }
    
    private func content(size: CGSize) -> some View {
        scene.initSize(screenSize: size)
        return ZStack {
            Color.white
            scene.dotsEditorView()
            if !scene.polygon.isEmpty {
                Path { path in
                    path.addLines(scene.polygon)
                    path.closeSubpath()
                }.fill().foregroundColor(scene.areaColor)
            }

            if let areaPos = scene.areaPos {
                Text(scene.area)
                    .position(areaPos).font(.title2).foregroundColor(.black)
            }
        }.onAppear() {
            scene.onAppear()
        }
    }

}
