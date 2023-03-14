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
            List($viewModel.items, selection: $viewModel.selection) { $item in
                NavigationLink(item.title, value: item.id)
            }
        } detail: {
            viewModel.contentView
        }.navigationTitle("iShape")
    }
}
