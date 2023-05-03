//
//  ConvexAndConvexSpaceView.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 28.04.2023.
//

import SwiftUI

struct ConvexAndConvexSpaceView: View {
    
    @ObservedObject
    var space: ConvexAndConvexSpace
    
    var body: some View {
        GeometryReader { proxy in
            content(size: proxy.size)
        }
    }
    
    private func content(size: CGSize) -> some View {
        space.initSize(screenSize: size)
        return ZStack {
            Color.white
            space.aEditor.makeView()
            space.bEditor.makeView()
            
            ForEach(space.normals) { vector in
                VectorShape(vector: vector)
                    .stroke(lineWidth: vector.stroke)
                    .foregroundColor( vector.color)
            }
            
            Path { path in
                path.addLines(space.rectA)
                path.closeSubpath()
            }.stroke(lineWidth: 1).foregroundColor(.blue)
            
            Path { path in
                path.addLines(space.rectB)
                path.closeSubpath()
            }.stroke(lineWidth: 1).foregroundColor(.yellow)
            
            Path { path in
                path.addLines(space.moveA)
                path.closeSubpath()
            }
            .strokedPath(.init(lineWidth: space.isIntersect ? 4 : 2))
            .foregroundColor(.orange.opacity(space.isIntersect ? 1 : 0.5))

            Path { path in
                path.addLines(space.moveB)
                path.closeSubpath()
            }
            .strokedPath(.init(lineWidth: space.isIntersect ? 4 : 2))
            .foregroundColor(.indigo.opacity(space.isIntersect ? 1 : 0.5))
            
            if !space.vertices.isEmpty {
                ForEach(0..<space.vertices.count, id: \.self) { id in
                    Circle()
                        .size(width: 12, height: 12)
                        .offset(space.vertices[id] - CGPoint(x: 6, y: 6))
                        .foregroundColor(.red)
                }
            }
            
            VStack {
                HStack {
                    Text("A angle: " + String(format: "%.2f", space.angA))
                        .lineLimit(1)
                        .frame(width: 100, alignment: .leading)
                        .padding([.leading, .trailing], 8).foregroundColor(.black)
                    Slider(value: $space.angA, in: 0...360).padding(.trailing, 8)
                }.padding(.top, 4)
                HStack {
                    Text("A pos X: " + String(format: "%.2f", space.posAx))
                        .lineLimit(1)
                        .frame(width: 100, alignment: .leading)
                        .padding([.leading, .trailing], 8).foregroundColor(.black)
                    Slider(value: $space.posAx, in: -40...40).padding(.trailing, 8)
                }.padding(.top, 4)
                HStack {
                    Text("A pos Y: " + String(format: "%.2f", space.posAy))
                        .lineLimit(1)
                        .frame(width: 100, alignment: .leading)
                        .padding([.leading, .trailing], 8).foregroundColor(.black)
                    Slider(value: $space.posAy, in: -40...40).padding(.trailing, 8)
                }.padding(.top, 4)
                HStack {
                    Text("B angle: " + String(format: "%.2f", space.angB))
                        .lineLimit(1)
                        .frame(width: 100, alignment: .leading)
                        .padding([.leading, .trailing], 8).foregroundColor(.black)
                    Slider(value: $space.angB, in: 0...360).padding(.trailing, 8)
                }.padding(.top, 4)
                HStack {
                    Text("B pos X: " + String(format: "%.2f", space.posBx))
                        .lineLimit(1)
                        .frame(width: 100, alignment: .leading)
                        .padding([.leading, .trailing], 8).foregroundColor(.black)
                    Slider(value: $space.posBx, in: -40...40).padding(.trailing, 8)
                }.padding(.top, 4)
                HStack {
                    Text("B pos Y: " + String(format: "%.2f", space.posBy))
                        .lineLimit(1)
                        .frame(width: 100, alignment: .leading)
                        .padding([.leading, .trailing], 8).foregroundColor(.black)
                    Slider(value: $space.posBy, in: -40...40).padding(.trailing, 8)
                }.padding(.top, 4)
                Spacer()
            }
        }
    }
}
