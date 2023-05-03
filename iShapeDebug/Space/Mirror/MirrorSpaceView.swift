//
//  MirrorSpaceView.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 20.04.2023.
//

import SwiftUI

struct MirrorSpaceView: View {
    
    @ObservedObject
    var space: MirrorSpace
    
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
            
            VectorShape(vector: space.ax)
                .stroke(lineWidth: 4)
                .foregroundColor(.blue)
            
            VectorShape(vector: space.bx)
                .stroke(lineWidth: 4)
                .foregroundColor(.green)

            VectorShape(vector: space.normal)
                .stroke(lineWidth: 2)
                .foregroundColor(.red)
            
            if space.line.count > 1 {
                Path { path in
                    path.move(to: space.line[0])
                    path.addLine(to: space.line[1])
                }
                .stroke(lineWidth: 2)
                .foregroundColor(.indigo)
            }
            
            VStack {
                HStack {
                    Text("angle: " + String(format: "%.2f", space.angle))
                        .lineLimit(1)
                        .frame(width: 100, alignment: .leading)
                        .padding([.leading, .trailing], 8).foregroundColor(.black)
                    Slider(value: $space.angle, in: 0...180).padding(.trailing, 8)
                }.padding(.top, 4)
                Spacer()
            }
        }
    }
}
