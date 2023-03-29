//
//  TesselationSpaceView.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 20.03.2023.
//

import SwiftUI

struct TesselationSpaceView: View {

    @ObservedObject
    var space: TesselationSpace
    
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
            VStack {
                space.testNavigator.makeView()
                HStack {
                    Text("maxEdge: " + String(format: "%.2f", space.maxEdge))
                        .lineLimit(1)
                        .frame(width: 100, alignment: .leading)
                        .padding([.leading, .trailing], 8).foregroundColor(.black)
                    Slider(value: $space.maxEdge, in: 1...50).padding(.trailing, 8)
                }.padding(.top, 4)
                HStack {
                    Text("factor: " + String(format: "%.2f", space.factor))
                        .lineLimit(1)
                        .frame(width: 100, alignment: .leading)
                        .padding([.leading, .trailing], 8).foregroundColor(.black)
                    Slider(value: $space.factor, in: 0.02...3).padding(.trailing, 8)
                }.padding(.top, 4)
                Spacer()
            }
        }.onAppear() {
            space.onAppear()
        }
    }
}
