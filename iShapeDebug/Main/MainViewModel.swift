//
//  MainViewModel.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 10.07.2023.
//

import SwiftUI
import iDebug

final class MainViewModel: ObservableObject {

    private let areaScene = AreaScene(id: 0)
    private var testStore: TestStore?

    private (set) var pIndex = PersistInt(key: "TestIndex", nilValue: 0)
    
    lazy var scenes: [SceneHandler] = [
        areaScene.handler
    ]

    @Published
    var sceneId: Int = 0 {
        didSet {
            self.update(id: sceneId)
        }
    }
    
    @Published
    var testId: Int = 0 {
        didSet {
            testStore?.testId = testId
        }
    }
    
    @Published
    var tests: [TestHandler] = []
    

    @ViewBuilder var sceneView: some View {
        switch sceneId {
        case 0:
            areaScene.makeView()
        default:
            fatalError("scene not set")
        }
    }
    
    func onAppear() {
        sceneId = pIndex.value
    }
    
    private func update(id: Int) {
        if sceneId != id {
            sceneId = id
        }
        
        if pIndex.value != id {
            pIndex.value = id
        }
        
        switch id {
        case 0:
            testStore = areaScene.testStore
        default:
            break
        }
        
        tests = testStore?.tests ?? []
    }
}
