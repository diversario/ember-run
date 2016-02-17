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
    let scene: GameScene
    let node: SKSpriteNode
    let physicsManager: PhysicsManager
    
    private var _positioned = false
    
    init(scene: GameScene, physicsManager: PhysicsManager) {
        self.scene = scene
        self.physicsManager = physicsManager
        node = SKSpriteNode(imageNamed: "player")
        
        initPlayerNode()
    }
    
    func initPlayerNode() {
        setPhysicsBody()
        
        node.name = "player"
        
        let constr = SKConstraint.positionX(SKRange(lowerLimit: self.scene.LEFT_EDGE + node.size.width / 2, upperLimit: scene.RIGHT_EDGE - node.size.width / 2))
        node.constraints = [constr]
    }
    
    func setPhysicsBody() {
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
        node.physicsBody!.contactTestBitMask = PhysicsManager.bodies.player | PhysicsManager.bodies.wheel
        
        node.physicsBody!.usesPreciseCollisionDetection = true
        node.physicsBody!.restitution = 0
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
            } else {
                //node.constraints!.first!.enabled = false
                setPhysicsBody()
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
            vector = normalizeVector(vector!)
            vector!.dx *= 3
            vector!.dy *= 3
        } else if isOnTheWall() {
            if playerCoords.x < 0 { // it's on the left wall
                vector = CGVectorMake(5, 5)
            } else {
                vector = CGVectorMake(-5, 5)
            }
            
            vector = normalizeVector(vector!)
            
            vector!.dx *= 3
            vector!.dy *= 3
        }
        
        return vector
    }
    
    func isOnTheWall () -> Bool {
        return node.position.x <= (scene.LEFT_EDGE + node.size.width / 2) ||
               node.position.x >= (scene.RIGHT_EDGE - node.size.width / 2)
    }
    
    func normalizeVector (v: CGVector) -> CGVector {
        let length = sqrt(pow(v.dx, 2) + pow(v.dy, 2))
        
        return CGVector(dx: v.dx/length, dy: v.dy/length)
    }
}
