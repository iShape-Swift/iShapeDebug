//
//  ColliderSolver.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 28.04.2023.
//

import iNetBox
import iSpace

struct ColliderSolver {

    private static let sameEps: Int64 = 3
    
    static func collide(a: ConvexCollider, b: ConvexCollider, tA: Transform, tB: Transform) -> Contact {
        var contact: Contact
        let t: Transform
        if a.points.count > b.points.count {
            // work in a coord system
            
            let mt = Transform.convert(from: tB, to: tA)
            let b2 = ConvexCollider(transform: mt, collider: b)
            
            contact = ColliderSolver.collide(a: a, b: b2)

            t = tA
        } else {
            // work in b coord system
            
            let mt = Transform.convert(from: tA, to: tB)
            let a2 = ConvexCollider(transform: mt, collider: a)
            
            contact = ColliderSolver.collide(a: b, b: a2)
            
            t = tB
        }


        guard contact.type == .collide else {
            return .outside
        }
        
        // return in global coord system
        return t.convert(contact: contact)
    }
    
    private static func collide(a: ConvexCollider, b: ConvexCollider) -> Contact {
        let cntA = ColliderSolver.findMinSeparation(a: a, b: b)

        if cntA.type == .collide && cntA.penetration > 10 {
            return .outside
        }

        let cntB = ColliderSolver.findMinSeparation(a: b, b: a)
        
        if cntB.type == .collide && cntB.penetration > 10 {
            return .outside
        }

        if cntB.type == .collide && cntA.type == .collide {
            if cntB.penetration > cntA.penetration {
                // A penetrate B
                return cntB
            } else {
                // A penetrate B
                return cntA
            }
        } else if cntB.type == .collide {
            return cntB
        } else if cntA.type == .collide {
            return cntA
        } else {
            return .outside
        }
    }
    
    private static func findMinSeparation(a: ConvexCollider, b: ConvexCollider) -> Contact {
        var contact_0: Contact = Contact(point: .zero, normal: .zero, penetration: .min, type: .outside)
        var contact_1: Contact = Contact(point: .zero, normal: .zero, penetration: .min, type: .outside)

        for vert in b.points {
            guard a.box.isContain(point: vert) else {
                continue
            }
            
            var sv = Int64.max
            var nv = FixVec.zero
            
            for e in 0..<a.points.count {
                let n = a.normals[e]
                let p = a.points[e]
                
                let d = vert - p
                let s = n.dotProduct(d)
                
                if s < sv {
                    sv = s
                    nv = n
                }
            }
            
            if sv >= contact_1.penetration {
                let newContact = Contact(point: vert, normal: nv, penetration: sv, type: .collide)

                if newContact.penetration > contact_0.penetration {
                    contact_0 = newContact
                } else {
                    contact_1 = newContact
                }
            }
            
        }

        if contact_0.type == .collide {
            if contact_1.penetration + sameEps >= contact_0.penetration {
                let mid = contact_0.point.middle(contact_1.point)
                return Contact(point: mid, normal: contact_0.normal, penetration: contact_0.penetration, type: .collide)
            } else {
                return contact_0
            }
        } else {
            return .outside
        }
    }

    
    private static func isEdgeContain(a: FixVec, b: FixVec, p: FixVec, n: FixVec) -> Bool {
        let aDot = (p - a).crossProduct(n)
        let bDot = (p - b).crossProduct(n)
        return aDot * bDot <= 0
    }
    
}
