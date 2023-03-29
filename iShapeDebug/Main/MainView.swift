//
//  MainView.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 13.03.2023.
//

import SwiftUI

struct MainView: View {
    
    @StateObject
    var viewModel = ViewModel()
    
    var body: some View {
        NavigationSplitView {
            List($viewModel.spaces, selection: $viewModel.selection) { $space in
                NavigationLink(space.title, value: space)
            }
        } detail: {
            viewModel.contentView
        }
        .navigationTitle("Title")
        .navigationSubtitle("Title")
        .onAppear() {
            viewModel.onAppear()
        }
    }
}
