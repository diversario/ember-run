//
//  Player.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 2/15/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit

class Player {
    private let _scene: GameScene
    private let _node: SKSpriteNode
    private let _physicsManager: PhysicsManager
    private var _positioned = false
    
    var position: CGPoint {
        return _node.position
    }
    
    init(scene: GameScene, physicsManager: PhysicsManager) {
        self._scene = scene
        self._physicsManager = physicsManager
        _node = SKSpriteNode(imageNamed: "player")
        
        _initPlayerNode()
    }
    
    func positionPlayer(pos: CGPoint) {
        if !_positioned {
            _node.position = pos
            _scene.addChild(_node)
            _positioned = true
        }
    }
    
    func onTap () {
        let impulse = getJumpVector()
        
        if impulse != nil {
            if _physicsManager.isPlayerOnWheel {
                _physicsManager.detachPlayerFromWheel()
            } else {
                _setPhysicsBody()
            }
            
            _node.physicsBody?.applyImpulse(impulse!)
        }
    }
    
    private func _initPlayerNode() {
        _setPhysicsBody()
        
        _node.name = "player"
        
        let constr = SKConstraint.positionX(
            SKRange(
                lowerLimit: _scene.LEFT_EDGE + _node.size.width / 2,
                upperLimit: _scene.RIGHT_EDGE - _node.size.width / 2
            )
        )
        _node.constraints = [constr]
    }
    
    private func _setPhysicsBody() {
        _node.physicsBody = SKPhysicsBody(circleOfRadius: _node.size.width/2)
        _node.physicsBody!.contactTestBitMask = PhysicsManager.bodies.player | PhysicsManager.bodies.wheel
        
        _node.physicsBody!.usesPreciseCollisionDetection = true
        _node.physicsBody!.restitution = 0
        _node.physicsBody!.linearDamping = 0.3
    }
    
    private func getJumpVector () -> CGVector? {
        let playerCoords = _node.position
        
        var vector: CGVector?
        
        if _physicsManager.isPlayerOnWheel {
            if let wheel = _physicsManager.wheel {
                vector = CGVectorMake(playerCoords.x - wheel.position.x, playerCoords.y - wheel.position.y)
                vector = normalizeVector(vector!)
                vector!.dx *= 3
                vector!.dy *= 3
            }
        } else if _isOnTheWall() {
            if playerCoords.x < 0 { // it's on the left wall
                vector = CGVectorMake(1, 1)
            } else {
                vector = CGVectorMake(-1, 1)
            }
            
            vector = normalizeVector(vector!)
            
            vector!.dx *= 2.5
            vector!.dy *= 2.5
        }
        
        return vector
    }
    
    private func _isOnTheWall () -> Bool {
        return _node.position.x <= (_scene.LEFT_EDGE + _node.size.width / 2) ||
               _node.position.x >= (_scene.RIGHT_EDGE - _node.size.width / 2)
    }
}
