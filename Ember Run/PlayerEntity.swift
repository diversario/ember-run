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
    
    override init() {
        super.init()
        
        let texture = SKTexture(imageNamed: "player")
        let sprite = SpriteComponent(texture: texture, size: texture.size())
        sprite.node.zPosition = Z.PLAYER
        sprite.node.position = CGPoint(x: 0, y: 0)
        sprite.node.name = "player"
        
        addComponent(sprite)
        resetPhysicsComponent()
        addComponent(PlayerFieldNodeComponent(sprite: sprite.node))
    }
    
    var sprite: SKSpriteNode {
        return componentForClass(SpriteComponent)!.node
    }

    func resetPhysicsComponent () {
        addComponent(PlayerPhysicsComponent(sprite: sprite))
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
    
    private func getJumpVector () -> CGVector? {
        let playerCoords = sprite.position
        
        var vector: CGVector?
        
        if isOnWheel {
            if let wheel = currentWheel {
                vector = CGVectorMake(playerCoords.x - wheel.position.x, playerCoords.y - wheel.position.y)
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
        if let joints = sprite.physicsBody?.joints where joints.count > 0 {
            let joint = joints[0]
            
            if joint.bodyA.node == sprite {
                return joint.bodyB.node as? SKSpriteNode
            } else {
                return joint.bodyA.node as? SKSpriteNode
            }
        }
        
        return nil
    }
    
    @available(*, unavailable)
    func orientToMovement (impulse: CGVector) {
        let angle = getPlayerRotationAngle(impulse)
        
        let rotate = SKAction.rotateToAngle(angle, duration: 0.03, shortestUnitArc: true)
        sprite.runAction(rotate)
    }
    
    
    func rotateToMovement () {
        if let vel = sprite.physicsBody?.velocity {
            let point_y = sprite.position.y - vel.dy
            let point_x = sprite.position.x - vel.dx
            
            let angle = atan2(point_y - sprite.position.y , point_x - sprite.position.x) + CGFloat((M_PI/180) * 90.0)
            
            sprite.zRotation = angle
        }
    }
    
    private let _angleAdjustment = CGFloat(90 * M_PI/180.0)
    
    func getPlayerRotationAngle(v: CGVector) -> CGFloat {
        return atan2(v.dy, v.dx) - _angleAdjustment
    }
}