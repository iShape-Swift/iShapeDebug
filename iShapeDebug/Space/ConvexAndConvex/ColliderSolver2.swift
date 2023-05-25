//
//  ContactSolver2.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 04.05.2023.
//

import iNetBox
import iSpace

struct ColliderSolver2 {

    private static let sameEps: Int64 = 3
    
    static func collide(a: ConvexCollider, b: ConvexCollider, tA: Transform, tB: Transform) -> [Contact] {
        var contacts: [Contact]
        let t: Transform
        if a.points.count > b.points.count {
            // work in a coord system
            
            let mt = Transform.convert(from: tB, to: tA)
            let b2 = ConvexCollider(transform: mt, collider: b)
            
            contacts = Self.collide(a: a, b: b2)

            t = tA
        } else {
            // work in b coord system
            
            let mt = Transform.convert(from: tA, to: tB)
            let a2 = ConvexCollider(transform: mt, collider: a)
            
            contacts = Self.collide(a: b, b: a2)
            
            t = tB
        }

        for i in 0..<contacts.count {
            contacts[i] = t.convert(contact: contacts[i])
        }

        // return in global coord system
        return contacts
    }
    
    private static func collide(a: ConvexCollider, b: ConvexCollider) -> [Contact] {
        let cntA = Self.findMinSeparation(a: a, b: b)

        if !cntA.isEmpty && cntA[0].penetration > 10 {
            return []
        }

        let cntB = Self.findMinSeparation(a: b, b: a)
        
        if !cntB.isEmpty && cntB[0].penetration > 10 {
            return []
        }

        return cntA + cntB
    }
    
    private static func findMinSeparation(a: ConvexCollider, b: ConvexCollider) -> [Contact] {
        var contact_0: Contact = Contact(point: .zero, normal: .zero, penetration: .max, type: .outside)
        var contact_1: Contact = Contact(point: .zero, normal: .zero, penetration: .max, type: .outside)

        for vert in b.points {
            guard a.isContain(point: vert) else {
                continue
            }
            
            var sv = Int64.min
            var nv = FixVec.zero
            
            for e in 0..<a.points.count {
                let n = a.normals[e]
                let p = a.points[e]
                
                let d = vert - p
                let s = n.dotProduct(d)
                
                if s > sv {
                    sv = s
                    nv = n
                }
            }
            
            if sv < contact_1.penetration {
                let newContact = Contact(point: vert, normal: nv, penetration: sv, type: .collide)

                if newContact.penetration < contact_0.penetration {
                    contact_0 = newContact
                } else {
                    contact_1 = newContact
                }
            }
            
        }
        
        
        if contact_0.type == .collide && contact_1.type == .collide {
            return [contact_0, contact_1]
        } else if contact_0.type == .collide {
            return [contact_0]
        } else {
            return []
        }
    }

}
