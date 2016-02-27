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
    
    var wheel: SKSpriteNode? {
        return _joint?.bodyB.node as? SKSpriteNode
    }
    
    init(scene: GameScene) {
        self._scene = scene
        super.init()

        self._scene.physicsWorld.contactDelegate = self
        
        _setNormalGravity()
    }
    
    deinit {
        print("DEINIT PHYSICS MANAGER")
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let (player, other) = _getBodies(contact)
        
        let mask = player.contactTestBitMask & other.categoryBitMask
        
        if mask == CAT.WHEEL {
            let wheel = other
            
            if _joint != nil {
                _scene.physicsWorld.removeJoint(_joint)
            }
            
            let vectorToContactPoint = CGVector(
                dx: contact.contactPoint.x - wheel.node!.position.x,
                dy: contact.contactPoint.y - wheel.node!.position.y
            )
            
            let normalizedVTCP = normalizeVector(vectorToContactPoint)
        
            let adjustedContactPoint = CGPoint(
                x: contact.contactPoint.x + 8*normalizedVTCP.dx,
                y: contact.contactPoint.y + 8*normalizedVTCP.dy
            )
            
            player.node!.position = adjustedContactPoint
            
            _joint = SKPhysicsJointFixed.jointWithBodyA(player, bodyB: wheel, anchor: contact.contactPoint)
            _scene.physicsWorld.addJoint(_joint)

            player.node!.constraints!.first!.enabled = true
        } else if mask == CAT.WATER {
            _playerInWater(player)
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        let (player, other) = _getBodies(contact)
        
        let mask = player.contactTestBitMask & other.categoryBitMask
        
        if mask == CAT.WATER {
            _playerOutOfWater(player)
        }
    }
    
    func detachPlayerFromWheel() {
        _scene.physicsWorld.removeJoint(_joint)
        _joint = nil
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
    
    private func _playerInWater (player: SKPhysicsBody) {
        _scene.player?.highDamping()
        _scene.player?.reduceVelocity()
        
        _setInWaterGravity()
        
        _scene.player?.startDying()
    }
    
    private func _playerOutOfWater (player: SKPhysicsBody) {
        _scene.player?.normalDamping()
        
        _scene.player?.stopDying()

        _setNormalGravity()
    }
    
    private func _setNormalGravity () {
        self._scene.physicsWorld.gravity = CGVector(dx: 0, dy: -2 * SCREEN_SCALE)
    }
    
    private func _setInWaterGravity () {
        self._scene.physicsWorld.gravity = CGVector(dx: 0, dy: -0.5 * SCREEN_SCALE)
    }
}