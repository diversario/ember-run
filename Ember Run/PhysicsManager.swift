//
//  PhysicsManager.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 2/14/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit

class PhysicsManager: NSObject, SKPhysicsContactDelegate {
    struct bodies {
        static let wheel: UInt32 = 0x1 << 0
        static let player: UInt32 = 0x1 << 1
        static let walls: UInt32 = 0x1 << 2
    }
    
    let scene: SKScene
    
    var joint: SKPhysicsJoint!
    
    init(scene: SKScene) {
        self.scene = scene
        super.init()

        self.scene.physicsWorld.contactDelegate = self
        self.scene.physicsWorld.gravity = CGVector(dx: 0, dy: -2)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let a = contact.bodyA
        let b = contact.bodyB
        
        if a.contactTestBitMask & b.contactTestBitMask == bodies.wheel | bodies.player {
            let p: SKPhysicsBody!
            let w: SKPhysicsBody!
            
            if contact.bodyA.node?.name == "player" {
                p = contact.bodyA
                w = contact.bodyB
            } else {
                p = contact.bodyB
                w = contact.bodyA
            }
            
            if joint != nil {
                scene.physicsWorld.removeJoint(joint)
            }
            
            let vectorToContactPoint = CGVector(
                dx: contact.contactPoint.x - w.node!.position.x,
                dy: contact.contactPoint.y - w.node!.position.y
            )
            
            let normalizedVTCP = normalizeVector(vectorToContactPoint)
            
            let adjustedContactPoint = CGPoint(
                x: contact.contactPoint.x + 8*normalizedVTCP.dx,
                y: contact.contactPoint.y + 8*normalizedVTCP.dy
            )
            
            p.node!.position = adjustedContactPoint
            
            joint = SKPhysicsJointFixed.jointWithBodyA(p, bodyB: w, anchor: contact.contactPoint)
            scene.physicsWorld.addJoint(joint)
            
            p.node!.constraints!.first!.enabled = true
        }
    }
    
    // also not used
    func angleBetweenPoints(a: CGPoint, _ b: CGPoint) -> CGFloat {
        let dx = b.x - a.x
        let dy = b.y - a.y
        
        return atan2(dy, dx)
    }
    
    // written because I'm an idiot. Unused
    func pointOnCircle(angle : CGFloat, circle: SKNode) -> CGPoint {
        let ox = circle.position.x + circle.frame.width / 2
        let oy = circle.position.y
        
        let point = CGPoint(
            x: ox * cos(angle) + oy * sin(angle),
            y: ox * sin(angle) + oy * cos(angle)
        )
        
        return point
    }
}