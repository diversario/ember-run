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
    let scene: SKScene
    let node: SKSpriteNode
    let physicsManager: PhysicsManager
    
    private var _positioned = false
    
    init(scene: SKScene, physicsManager: PhysicsManager) {
        self.scene = scene
        self.physicsManager = physicsManager
        node = SKSpriteNode(imageNamed: "player")
        
        initPlayerNode()
    }
    
    func initPlayerNode() {
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
        node.physicsBody!.contactTestBitMask = PhysicsManager.bodies.wheel |
            PhysicsManager.bodies.player |
            PhysicsManager.bodies.walls
        
        node.physicsBody!.usesPreciseCollisionDetection = true
        node.physicsBody!.restitution = 1
        
        node.name = "player"
    }
    
    func positionPlayer(pos: CGPoint) {
        if !_positioned {
            node.position = pos
            scene.addChild(node)
            _positioned = true
        }
    }
    
    func onTap () {
        let impulse = getJumpVector()
        
        if impulse != nil {
            if physicsManager.joint != nil {
                scene.physicsWorld.removeJoint(physicsManager.joint)
                physicsManager.joint = nil
            }
            
            node.physicsBody?.applyImpulse(impulse!)
        }
    }
    
    func getJumpVector () -> CGVector? {
        let playerCoords = node.position
        
        var vector: CGVector?
        
        if physicsManager.joint != nil {
            let attachedBody = physicsManager.joint.bodyB
            
            vector = CGVectorMake(playerCoords.x - attachedBody.node!.position.x, playerCoords.y - attachedBody.node!.position.y)
            
            vector!.dx /= 50
            vector!.dy /= 50
        } else if physicsManager.constraint != nil {
            print(playerCoords)
            if playerCoords.x < 0 { // it's on the left wall
                vector = CGVectorMake(2, 2)
            } else {
                vector = CGVectorMake(-2, 2)
            }
        
            physicsManager.constraint.enabled = false
            physicsManager.constraint = nil
            node.constraints = [SKConstraint]()
        }
        
        return vector
    }
}
