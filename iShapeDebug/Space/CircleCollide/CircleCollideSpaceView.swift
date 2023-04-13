//
//  CircleCollideSpaceView.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 10.04.2023.
//

import SwiftUI

struct CircleCollideSpaceView: View {
    
    @ObservedObject
    var space: CircleCollideSpace
    
    var body: some View {
        GeometryReader { proxy in
            content(size: proxy.size)
        }
    }
    
    private func content(size: CGSize) -> some View {
        space.initSize(screenSize: size)
        return ZStack {
            Color.white
  
            space.dotEditor.makeView()
            
            if space.ciRadiusA > 0 {
                Circle()
                    .size(width: 2 * space.ciRadiusA, height: 2 * space.ciRadiusA)
                    .offset(space.ciCenterA)
                    .stroke(lineWidth: 1).foregroundColor(.green)
            }
            
            if space.ciRadiusB > 0 {
                Circle()
                    .size(width: 2 * space.ciRadiusB, height: 2 * space.ciRadiusB)
                    .offset(space.ciCenterB)
                    .stroke(lineWidth: 1).foregroundColor(.green)
            }
            if let contact = space.contact {
                Circle()
                    .size(width: 8, height: 8)
                    .offset(contact)
                    .foregroundColor(.red)
            }
            if let normal = space.normal {
                VectorShape(vector: normal)
                    .stroke(lineWidth: 2)
                    .foregroundColor(.green)
            }

        }
    }
}
