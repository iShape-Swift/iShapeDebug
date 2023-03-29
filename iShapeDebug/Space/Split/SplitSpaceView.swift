//
//  SplitSpaceView.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 22.03.2023.
//

import SwiftUI

struct SplitSpaceView: View {

    @ObservedObject
    var space: SplitSpace
    
    var body: some View {
        GeometryReader { proxy in
            content(size: proxy.size)
        }
    }
    
    private func content(size: CGSize) -> some View {
        space.initSize(screenSize: size)
        return ZStack {
            Color.white
            Path { path in
                for edge in space.edges {
                    path.move(to: edge.a)
                    path.addLine(to: edge.b)
                }
            }.strokedPath(.init(lineWidth: 1)).foregroundColor(.gray)
            space.editor.makeView()
            
            ForEach(space.shapes) { shape in
                Path { path in
                    path.addLines(shape.points)
                    path.closeSubpath()
                }.strokedPath(.init(lineWidth: 4)).foregroundColor(shape.color)
            }
            
            VStack {
                space.testNavigator.makeView()
                HStack {
                    Text("scale: " + String(format: "%.2f", space.scale))
                        .lineLimit(1)
                        .frame(width: 100, alignment: .leading)
                        .padding([.leading, .trailing], 8).foregroundColor(.black)
                    Slider(value: $space.scale, in: 0.05...1).padding(.trailing, 8)
                }.padding(.top, 4)
                HStack {
                    Text("radius: " + String(format: "%.2f", space.radius))
                        .lineLimit(1)
                        .frame(width: 100, alignment: .leading)
                        .padding([.leading, .trailing], 8).foregroundColor(.black)
                    Slider(value: $space.radius, in: 0.5...21).padding(.trailing, 8)
                }.padding(.top, 4)
                HStack {
                    Text("maxEdge: " + String(format: "%.2f", space.maxEdge))
                        .lineLimit(1)
                        .frame(width: 100, alignment: .leading)
                        .padding([.leading, .trailing], 8).foregroundColor(.black)
                    Slider(value: $space.maxEdge, in: 1...50).padding(.trailing, 8)
                }.padding(.top, 4)
                HStack {
                    Text("tesFactor: " + String(format: "%.2f", space.tesFactor))
                        .lineLimit(1)
                        .frame(width: 100, alignment: .leading)
                        .padding([.leading, .trailing], 8).foregroundColor(.black)
                    Slider(value: $space.tesFactor, in: 0.02...3).padding(.trailing, 8)
                }.padding(.top, 4)
                Spacer()
            }
        }.onAppear() {
            space.onAppear()
        }
    }
}
