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
    private unowned let _scene: GameScene
    private var _joint: SKPhysicsJoint!
    private var _isPlayerInWater = false
    
    var isPlayerOnWheel: Bool {
        return _joint != nil
    }
    
    var wheel: Wheel? {
        return _joint?.bodyB.node as? Wheel
    }
    
    init(scene: GameScene) {
        self._scene = scene
        super.init()

        self._scene.physicsWorld.contactDelegate = self
        
        setNormalGravity()
    }
    
    deinit {
        print("DEINIT PHYSICS MANAGER")
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let (player, other) = _getBodies(contact)
        
        let mask = player.contactTestBitMask & other.categoryBitMask
        
        if mask == CAT.WHEEL {
            let wheelPB = other
            
            if let wheel = wheelPB.node as? Wheel, playerInstance = Player.getPlayer() {
                if _joint != nil {
                    _scene.physicsWorld.removeJoint(_joint)
                }
            
                let vectorToContactPoint = CGVector(
                    dx: contact.contactPoint.x - wheel.positionInScene.x,
                    dy: contact.contactPoint.y - wheel.positionInScene.y
                )
                
                let distanceFromWheelCenter = wheel.radius + playerInstance.radius
                
                let multiplier = distanceFromWheelCenter / vectorLength(vectorToContactPoint)
                
                let adjustedContactPoint = CGPoint(
                    x: wheel.positionInScene.x + multiplier * vectorToContactPoint.dx,
                    y: wheel.positionInScene.y + multiplier * vectorToContactPoint.dy
                )
                
                player.node!.position = adjustedContactPoint
                
                let angle = getPlayerRotationAngle(vectorToContactPoint)
                playerInstance.zRotation = angle
                playerInstance.isOnWheel = wheel
                
                self._joint = SKPhysicsJointFixed.jointWithBodyA(player, bodyB: wheelPB, anchor: contact.contactPoint)
                self._scene.physicsWorld.addJoint(self._joint)
            }
        }
    }
    
    func detachPlayerFromWheel() {
        _scene.physicsWorld.removeJoint(_joint)
        _joint = nil
        
        if let playerInstance = Player.getPlayer() {
            playerInstance.isOnWheel = nil
        }
    }
    
    private func _getBodies (contact: SKPhysicsContact) -> (SKPhysicsBody, SKPhysicsBody) {
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
    
     func setInWaterGravity () {
        self._scene.physicsWorld.gravity = CGVector(dx: 0, dy: -0.5 * SCREEN_SCALE)
    }
}