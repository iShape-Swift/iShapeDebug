//
//  WorkSpace.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 13.03.2023.
//

import SwiftUI

enum WorkSpace: String {

    
    var id: String { rawValue }
    
    case tringulation
    case clipping
    case earhquake
    
    var view: any View {
        switch self {
        case .tringulation:
            return Text(self.rawValue)
        case .clipping:
            return Text(self.rawValue)
        case .earhquake:
            return Text(self.rawValue)
        }
    }
    
    
}
