//
//  Main+ViewModel.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 13.03.2023.
//

import SwiftUI

extension MainView {

    struct MenuItem: Identifiable {
        
        let id: Int
        let workSpace: WorkSpace
        var title: String
        
        init(id: Int, workSpace: WorkSpace) {
            self.id = id
            self.workSpace = workSpace
            self.title = workSpace.rawValue
        }
        
    }
    
    
    final class ViewModel: ObservableObject {

        var items: [MenuItem] = [
            MenuItem(id: 0, workSpace: .tringulation),
            MenuItem(id: 1, workSpace: .clipping)
        ]
        
        @Published
        var selection: Int = 0 {
            didSet {
                let item = items.first(where: { $0.id == selection })
            }
        }

        @ViewBuilder var contentView: some View {
            let item = items.first(where: { $0.id == selection })
            
            switch item?.workSpace {
            case .tringulation:
                TriangulationSpace()
            case .clipping:
                Text("clipping")
            case .earhquake:
                Text("earhquake")
            case .none:
                Text("earhquake")
            }
        }
        
    }
    
}

