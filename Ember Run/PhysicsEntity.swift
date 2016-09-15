//
//  PhysicsManager.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 2/14/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class PhysicsEntity: GKEntity, SKPhysicsContactDelegate {
    private unowned let _scene: GameScene
    private var _joint: SKPhysicsJoint!
    private var _isPlayerInWater = false
    
    var isPlayerOnWheel: Bool {
        return _joint != nil
    }
    
    var wheel: SKSpriteNode? {
        return _joint?.bodyB.node as? SKSpriteNode
    }
    
    init(scene: GameScene) {
        self._scene = scene
        super.init()
        
        self._scene.physicsWorld.contactDelegate = self
        
        setNormalGravity()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DEINIT PhysicsEntity")
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let (player, other) = _getBodies(contact)
        
        let mask = player.contactTestBitMask & other.categoryBitMask
        
        if mask == CAT.WHEEL {
            let wheelPB = other
            
            if let wheel = wheelPB.node as? SKSpriteNode, let p = player.node as? SKSpriteNode {
                if _joint != nil {
                    _scene.physicsWorld.remove(_joint)
                }
                
                let vectorToContactPoint = CGVector(
                    dx: contact.contactPoint.x - wheel.position.x,
                    dy: contact.contactPoint.y - wheel.position.y
                )
                
                let distanceFromWheelCenter = wheel.size.width / 2 + p.size.width / 2
                
                let multiplier = distanceFromWheelCenter / vectorLength(vectorToContactPoint)
                
                let adjustedContactPoint = CGPoint(
                    x: wheel.position.x + multiplier * vectorToContactPoint.dx,
                    y: wheel.position.y + multiplier * vectorToContactPoint.dy
                )
                
                player.node!.position = adjustedContactPoint
                
                let angle = getPlayerRotationAngle(vectorToContactPoint)
                p.zRotation = angle
                
                self._joint = SKPhysicsJointFixed.joint(withBodyA: player, bodyB: wheelPB, anchor: contact.contactPoint)
                self._scene.physicsWorld.add(self._joint)
            }
        } else {
            print(player.node!.name, other.node!.name)
        }
    }
    
    
    func detachPlayerFromWheel() {
        _scene.physicsWorld.remove(_joint)
        _joint = nil
    }
    
    private func _getBodies (_ contact: SKPhysicsContact) -> (SKPhysicsBody, SKPhysicsBody) {
        let p: SKPhysicsBody!
        let w: SKPhysicsBody!
        
        if contact.bodyA.node?.name == "player" {
            p = contact.bodyA
            w = contact.bodyB
        } else {
            p = contact.bodyB
            w = contact.bodyA
        }
        
        return (p, w)
    }
    
    func setNormalGravity () {
        self._scene.physicsWorld.gravity = CGVector(dx: 0, dy: -2 * SCREEN_SCALE)
    }
}
