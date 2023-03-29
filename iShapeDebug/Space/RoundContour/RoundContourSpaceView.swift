//
//  RoundContourSpaceView.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 22.03.2023.
//

import SwiftUI

struct RoundContourSpaceView: View {
    
    @ObservedObject
    var space: RoundContourSpace
    
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
            
            Path { path in
                path.addLines(space.roundPoints)
                path.closeSubpath()
            }.strokedPath(.init(lineWidth: 4)).foregroundColor(.red)
            
            Circle()
                .size(width: 8, height: 8)
                .offset(space.centerPoint)
                .foregroundColor(.red)
            
            VStack {
                HStack {
                    Text(String(format: "%.2f", space.offset))
                        .lineLimit(1)
                        .frame(width: 50)
                        .padding([.leading, .trailing], 8).foregroundColor(.black)
                    Slider(value: $space.offset, in: 0...20).padding(.trailing, 8)
                }.padding(.top, 4)
                HStack {
                    Text(String(format: "%.2f", space.radius))
                        .lineLimit(1)
                        .frame(width: 50)
                        .padding([.leading, .trailing], 8).foregroundColor(.black)
                    Slider(value: $space.radius, in: 0.5...21).padding(.trailing, 8)
                }.padding(.top, 4)
                HStack {
                    Text(String(format: "%.2f", space.ratio))
                        .lineLimit(1)
                        .frame(width: 50)
                        .padding([.leading, .trailing], 8).foregroundColor(.black)
                    Slider(value: $space.ratio, in: 0.05...0.5).padding(.trailing, 8)
                }.padding(.top, 4)
                Spacer()
            }
        }
    }
}
