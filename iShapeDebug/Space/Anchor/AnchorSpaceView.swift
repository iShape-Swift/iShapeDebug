//
//  AnchorSpaceView.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 25.03.2023.
//

import SwiftUI

struct AnchorSpaceView: View {
    
    @ObservedObject
    var space: AnchorSpace
    
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
            
            ForEach(space.cornerEdges) { vector in
                VectorShape(vector: vector)
                    .stroke(lineWidth: 2)
                    .foregroundColor(.green)
            }
            
            Circle()
                .size(width: 2 * space.center.radius, height: 2 * space.center.radius)
                .offset(space.center.center)
                .foregroundColor(space.center.color)
            
            VStack {
                HStack {
                    Text("aL: " + String(format: "%.2f", space.aL))
                        .lineLimit(1)
                        .frame(width: 100, alignment: .leading)
                        .padding([.leading, .trailing], 8).foregroundColor(.black)
                    Slider(value: $space.aL, in: 1...500).padding(.trailing, 8)
                }.padding(.top, 4)
                HStack {
                    Text("bL: " + String(format: "%.2f", space.bL))
                        .lineLimit(1)
                        .frame(width: 100, alignment: .leading)
                        .padding([.leading, .trailing], 8).foregroundColor(.black)
                    Slider(value: $space.bL, in: 1...500).padding(.trailing, 8)
                }.padding(.top, 4)
                Spacer()
            }
        }
    }
}
