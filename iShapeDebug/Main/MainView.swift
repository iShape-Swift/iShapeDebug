//
//  MainView.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 10.07.2023.
//

import SwiftUI

struct MainView: View {
    
    @StateObject
    var viewModel = MainViewModel()
    
    var body: some View {
        NavigationSplitView {
            List(viewModel.scenes, selection: $viewModel.sceneId) { scene in
                Text(scene.title)
            }
        } content: {
            ZStack {
                Color.pink
                List(viewModel.tests, selection: $viewModel.testId) { test in
                    Text(test.title)
                }
            }
        } detail: {
            viewModel.sceneView
        }
        .navigationTitle("Shape App")
        .navigationSubtitle("Test")
        .onAppear() {
            viewModel.onAppear()
        }
    }
}
