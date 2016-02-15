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
        node.physicsBody!.contactTestBitMask = PhysicsManager.bodies.wheel | PhysicsManager.bodies.player
        node.physicsBody!.usesPreciseCollisionDetection = true
        
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
        if physicsManager.joint != nil {
            let impulse = getJumpVector()
            
            scene.physicsWorld.removeJoint(physicsManager.joint)
            physicsManager.joint = nil
            
            node.physicsBody?.applyImpulse(impulse)
            return
        }
    }
    
    func getJumpVector () -> CGVector {
        let playerCoords = node.position
        let wheelCoords = physicsManager.joint.bodyB.node!.position
        
        var vector = CGVectorMake(playerCoords.x - wheelCoords.x, playerCoords.y - wheelCoords.y)
        
        vector.dx /= 50
        vector.dy /= 50
        print(vector)
        return vector
    }
}
