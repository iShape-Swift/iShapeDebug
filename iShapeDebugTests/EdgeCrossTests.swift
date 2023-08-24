//
//  EdgeCrossTests.swift
//  iShapeDebugTests
//
//  Created by Nail Sharipov on 10.08.2023.
//

import XCTest
import iShape
import iFixFloat

final class EdgeCrossTests: XCTestCase {

    func test_simpleCross() throws {
        let s: Int64 = 1024
        
        let eA = FixEdge(e0: FixVec(-s, 0), e1: FixVec(s, 0))
        let eB = FixEdge(e0: FixVec(0, -s), e1: FixVec(0, s))
        
        let result = eA.cross(eB)
        
        XCTAssertEqual(EdgeCrossType.pure, result.type)
        XCTAssertEqual(FixVec.zero, result.point)
    }

    
    func test_bigCross_1() throws {
        let s: Int64 = 1024_000_000
        let eA = FixEdge(e0: FixVec(-s, 0), e1: FixVec(s, 0))
        let eB = FixEdge(e0: FixVec(0, -s), e1: FixVec(0, s))
        
        let result = eA.cross(eB)
        
        XCTAssertEqual(EdgeCrossType.pure, result.type)
        XCTAssertEqual(FixVec.zero, result.point)
    }

    
    func test_bigCross_2() throws {
        let s: Int64 = 1024_000_000
        let eA = FixEdge(e0: FixVec(-s, 0), e1: FixVec(s, 0))
        let eB = FixEdge(e0: FixVec(1024, -s), e1: FixVec(1024, s))
        
        let result = eA.cross(eB)
        
        XCTAssertEqual(EdgeCrossType.pure, result.type)
        XCTAssertEqual(FixVec(1024, 0), result.point)
    }
    
    func test_bigCross_3() throws {
        let s: Int64 = 1024_000_000
        let q: Int64 = s / 2
        let eA = FixEdge(e0: FixVec(-s, -s), e1: FixVec(s, s))
        let eB = FixEdge(e0: FixVec(q, -s), e1: FixVec(q, s))
        
        let result = eA.cross(eB)
        
        XCTAssertEqual(EdgeCrossType.pure, result.type)

        XCTAssertEqual(FixVec(512_000_000, 512_000_000), result.point)
    }
    
    func test_leftEnd() throws {
        let s: Int64 = 1024_000_000
        let eA = FixEdge(e0: FixVec(-s, 0), e1: FixVec(s, 0))
        let eB = FixEdge(e0: FixVec(-s, -s), e1: FixVec(-s, s))
        
        let result = eA.cross(eB)
        
        XCTAssertEqual(EdgeCrossType.end_a, result.type)
        XCTAssertEqual(FixVec(-s, 0), result.point)
    }
    
    func test_rightEnd() throws {
        let s: Int64 = 1024_000_000
        let eA = FixEdge(e0: FixVec(-s, 0), e1: FixVec(s, 0))
        let eB = FixEdge(e0: FixVec(s, -s), e1: FixVec(s, s))
        
        let result = eA.cross(eB)
        
        XCTAssertEqual(EdgeCrossType.end_a, result.type)
        XCTAssertEqual(FixVec(s, 0), result.point)
    }
    
    func test_LeftTop() throws {
        let s: Int64 = 1024_000_000
        let eA = FixEdge(e0: FixVec(-s, s), e1: FixVec(s, s))
        let eB = FixEdge(e0: FixVec(-s, s), e1: FixVec(-s, -s))
        
        let result = eA.cross(eB)
        
        XCTAssertEqual(EdgeCrossType.not_cross, result.type)
    }
    
    func test_RealCrash_1() throws {
        let eA = FixEdge(e0: FixVec(-8555798, -1599355), e1: FixVec(-1024000, 0))
        let eB = FixEdge(e0: FixVec(-8571363, 1513719), e1: FixVec(-1023948, -10239))
        
        let result = eA.cross(eB)
        
        XCTAssertEqual(EdgeCrossType.pure, result.type)
        XCTAssertEqual(FixVec(-1048691, -5244), result.point)
    }
    
    func test_RealCrash_2() throws {
        let eA = FixEdge(e0: FixVec(-8555798, -1599355), e1: FixVec(513224, -5243))
        let eB = FixEdge(e0: FixVec(-8555798, -1599355), e1: FixVec(513224, -5243))
        
        let result = eA.cross(eB)
        
        XCTAssertEqual(EdgeCrossType.not_cross, result.type)
    }
    
    func test_RealCase_1() throws {
        let eA = FixEdge(e0: FixVec(7256, -14637), e1: FixVec(7454, -15045))
        let eB = FixEdge(e0: FixVec(7343, -14833), e1: FixVec(7506, -15144))
        
        let result = eA.cross(eB)
        
        XCTAssertTrue(eA.isBoxContain(result.point))
        XCTAssertTrue(eB.isBoxContain(result.point))
        
        XCTAssertEqual(EdgeCrossType.pure, result.type)
    }
    
    func test_Penetrate_0() throws {
        let s: Int64 = 1024
        let eA = FixEdge(e0: FixVec(-s, 0), e1: FixVec(s / 2, 0))
        let eB = FixEdge(e0: FixVec( 0, 0), e1: FixVec(s, 0))
        
        let result = eA.cross(eB)
        
        XCTAssertEqual(EdgeCrossType.penetrate, result.type)
        XCTAssertEqual(FixVec(0, 0), result.point)
        XCTAssertEqual(FixVec(512, 0), result.second)
    }
    
}

private extension FixEdge {
    func isBoxContain(_ p: FixVec) -> Bool {
        let xCondition = e0.x <= p.x && p.x <= e1.x || e1.x <= p.x && p.x <= e0.x
        let yCondition = e0.y <= p.y && p.y <= e1.y || e1.y <= p.y && p.y <= e0.y
        return xCondition && yCondition
    }
}
