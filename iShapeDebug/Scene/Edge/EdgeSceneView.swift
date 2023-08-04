//
//  EdgeSceneView.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 10.07.2023.
//

import SwiftUI
import iDebug

struct EdgeSceneView: View {
 
    @ObservedObject
    var scene: EdgeScene
    
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
            VStack {
                Button("Print Test") {
                    scene.printTest()
                }.buttonStyle(.borderedProminent).padding()
                Button("Solve") {
                    scene.solve()
                }.buttonStyle(.borderedProminent).padding()
                HStack {
                    Text("Edge A").font(.title2).foregroundColor(EdgeScene.colorA)
                    Text("Edge B").font(.title2).foregroundColor(EdgeScene.colorB)
                    Text(scene.crossResult).font(.title2).foregroundColor(.gray)
                }
                Spacer()
            }
            scene.dotsEditorView()
            
            if let edge = scene.edgeA {
                Path { path in
                    path.move(to: edge.a)
                    path.addLine(to: edge.b)
                }.stroke(style: .init(lineWidth: 4, lineCap: .round)).foregroundColor(scene.colorA)
            }
           
            if let edge = scene.edgeB {
                Path { path in
                    path.move(to: edge.a)
                    path.addLine(to: edge.b)
                }.stroke(style: .init(lineWidth: 4, lineCap: .round)).foregroundColor(scene.colorB)
            }
            ForEach(0..<scene.crossVecs.count, id: \.self) { id in
                CircleView(position: scene.crossVecs[id], radius: 6, color: .red)
            }
        }.onAppear() {
            scene.onAppear()
        }
    }

}
