//
//  PlayerEntity.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 8/31/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class PlayerEntity: GKEntity {
    var delegate: PlayerDelegate?
    fileprivate let health = PlayerHealthComponent()
    
    override init() {
        super.init()
        
        let texture = SKTexture(imageNamed: "player")
        let sprite = SpriteComponent(texture: texture, size: texture.size())
        sprite.node.zPosition = Z.PLAYER
        sprite.node.position = CGPoint(x: 0, y: 0)
        sprite.node.name = "player"
        
        addComponent(sprite)
        addComponent(health)
        resetPhysicsComponent()
        addComponent(PlayerFieldNodeComponent(sprite: sprite.node))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DEINIT PlayerEntity")
    }
    
    func updateWithDeltaTime(_ seconds: TimeInterval, hazardEdge: CGFloat) {
        rotateToMovement()
        
        let shouldDecrease = sprite.position.y < hazardEdge
        
        health.update(seconds, shouldDecrease: shouldDecrease)
    }
    
    var sprite: SKSpriteNode {
        return component(ofType: SpriteComponent.self)!.node
    }

    func resetPhysicsComponent () {
        addComponent(PlayerPhysicsComponent(sprite: sprite))
    }
    
    var isDead: Bool {
        return health.health <= 0
    }
    
    func onTap () {
        if let impulse = getJumpVector() {
            if isOnWheel {
                delegate?.detachFromWheel()
            } else {
                resetPhysicsComponent()
            }
            
            sprite.physicsBody?.applyImpulse(impulse)
        }
    }
    
    fileprivate func getJumpVector () -> CGVector? {
        let playerCoords = sprite.position
        
        var vector: CGVector?
        
        if isOnWheel {
            if let wheel = currentWheel {
                vector = CGVector(dx: playerCoords.x - wheel.position.x, dy: playerCoords.y - wheel.position.y)
                vector = normalizeVector(vector!)
                
                vector!.dx *= IMPULSE.WHEEL
                vector!.dy *= IMPULSE.WHEEL
            }
        }
        
        return vector
    }
    
    var isOnWheel: Bool {
        return sprite.physicsBody!.joints.count > 0
    }
    
    var currentWheel: SKSpriteNode? {
        if let joints = sprite.physicsBody?.joints , joints.count > 0 {
            let joint = joints[0]
            
            if joint.bodyA.node == sprite {
                return joint.bodyB.node as? SKSpriteNode
            } else {
                return joint.bodyA.node as? SKSpriteNode
            }
        }
        
        return nil
    }
    
    func rotateToMovement () {
        if isOnWheel {
            return
        }
        
        if let vel = sprite.physicsBody?.velocity {
            let point_y = sprite.position.y - vel.dy
            let point_x = sprite.position.x - vel.dx
            
            let angle = atan2(point_y - sprite.position.y , point_x - sprite.position.x) + CGFloat((M_PI/180) * 90.0)
            
            sprite.zRotation = angle
        }
    }
    
    fileprivate let _angleAdjustment = CGFloat(90 * M_PI/180.0)
    
    func getPlayerRotationAngle(_ v: CGVector) -> CGFloat {
        return atan2(v.dy, v.dx) - _angleAdjustment
    }
}
