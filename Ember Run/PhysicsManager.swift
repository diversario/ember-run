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
    
    private let _scene: SKScene
    private var _joint: SKPhysicsJoint!
    
    var isPlayerOnWheel: Bool {
        return _joint != nil
    }
    
    var wheel: SKSpriteNode? {
        return _joint?.bodyB.node as? SKSpriteNode
    }
    
    init(scene: SKScene) {
        self._scene = scene
        super.init()

        self._scene.physicsWorld.contactDelegate = self
        self._scene.physicsWorld.gravity = CGVector(dx: 0, dy: -2)
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
            
            if _joint != nil {
                _scene.physicsWorld.removeJoint(_joint)
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
            
            _joint = SKPhysicsJointFixed.jointWithBodyA(p, bodyB: w, anchor: contact.contactPoint)
            _scene.physicsWorld.addJoint(_joint)
            
            p.node!.constraints!.first!.enabled = true
        }
    }
    
    func detachPlayerFromWheel() {
        _scene.physicsWorld.removeJoint(_joint)
        _joint = nil
    }
}