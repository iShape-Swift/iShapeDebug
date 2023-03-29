//
//  TestNavigatorView.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 18.03.2023.
//

import SwiftUI

struct TestNavigatorView: View {
    
    @ObservedObject
    var navigator: TestNavigator
    
    var body: some View {
        HStack {
            Button("Prev") {
                navigator.prev()
            }.padding().buttonStyle(.borderedProminent).tint(.pink)
            Spacer()
            Text("\(navigator.index)").foregroundColor(.black)
            Spacer()
            Button("Next") {
                navigator.next()
            }.padding().buttonStyle(.borderedProminent).tint(.pink)
        }
    }
}
