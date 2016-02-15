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
            
            joint = SKPhysicsJointFixed.jointWithBodyA(p, bodyB: w, anchor: contact.contactPoint)
            scene.physicsWorld.addJoint(joint)
        } else if a.contactTestBitMask & b.contactTestBitMask == bodies.walls | bodies.player {
            let p: SKPhysicsBody!
            let w: SKPhysicsBody!
            
            if contact.bodyA.node?.name == "player" {
                p = contact.bodyA
                w = contact.bodyB
            } else {
                p = contact.bodyB
                w = contact.bodyA
            }
            
            joint = SKPhysicsJointFixed.jointWithBodyA(p, bodyB: w, anchor: contact.contactPoint)
            scene.physicsWorld.addJoint(joint)
        }
    }
}