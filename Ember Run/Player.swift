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
    private unowned let _scene: GameScene
    private let _node: SKSpriteNode
    private unowned let _physicsManager: PhysicsManager
    private var _positioned = false
    private var _health = 100
    private var _isDying = false
    
    var position: CGPoint {
        return _node.position
    }
    
    var velocity: CGVector {
        return _node.physicsBody!.velocity
    }
    
    var health: Int {
        return _health
    }
    
    init(scene: GameScene, physicsManager: PhysicsManager) {
        self._scene = scene
        self._physicsManager = physicsManager
        
        _node = SKSpriteNode(imageNamed: "player")
        _node.zPosition = Z.PLAYER

    }
    
    deinit {
        print("DEINIT PLAYER")
    }
    
    func positionPlayer(pos: CGPoint) {
        if !_positioned {
            _node.position = pos
            
            _initPlayerNode()
            
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
        _node.physicsBody!.contactTestBitMask = BODY.PLAYER | BODY.WHEEL | BODY.WATER
        _node.physicsBody!.collisionBitMask = BODY.PLAYER | BODY.WHEEL
        _node.physicsBody!.categoryBitMask = CAT.PLAYER
        
        _node.physicsBody!.usesPreciseCollisionDetection = true
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
    
    private func _isOnWheel () -> Bool {
        if let name = _node.parent?.name {
            return name.containsString("wheel")
        }
        
        return false
    }
    
    func startDying () {
        _node.runAction(_getDecreaseHealthAction())
    }
    
    func stopDying () {
        _node.removeAllActions()
        _isDying = false
    }
    
    private func _getDecreaseHealthAction () -> SKAction {
        let wait = SKAction.waitForDuration(0.7)
        
        let decreaseHealth = SKAction.runBlock { _ in
            self._isDying = true
            self._startDecreasingHealth()
        }
        
        return SKAction.sequence([wait, decreaseHealth])
    }
    
    private func _startDecreasingHealth() {
        if _health <= 0 {
            return
        }
        
        let delta: Int64 = 10 * Int64(NSEC_PER_SEC / 1000)
        let time = dispatch_time(DISPATCH_TIME_NOW, delta)
        
        dispatch_after(time, dispatch_get_main_queue(), {
            self._health--
            print("DIE!!!!!!!", self.health)
            
            if self._isDying {
                self._startDecreasingHealth()
            }
        });
    }
}
