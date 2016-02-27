//
//  Water.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 2/18/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit

class Water {
    private var _node: SKSpriteNode!
    private unowned var _scene: GameScene
    
    init (scene: GameScene) {
        _scene = scene
        
        _initNode()
    }
    
    deinit {
        print("DEINIT WATER")
    }
    
    private func _initNode () {
        _node = SKSpriteNode(imageNamed: "water1")
        _node.zPosition = Z.WATER
        
        _node.position.x = _scene.LEFT_EDGE + _node.frame.width / 2
        _node.position.y = _scene.camera!.position.y - _scene.size.height/2
        
        _node.alpha = 0.5
        
        _node.physicsBody = SKPhysicsBody(rectangleOfSize: _node.frame.size)
        _node.physicsBody!.contactTestBitMask = CONTACT_MASK.WATER
        _node.physicsBody!.collisionBitMask = COLLISION_MASK.WATER
        _node.physicsBody!.categoryBitMask = CAT.WATER
        _node.physicsBody!.dynamic = false
        
        let textures = [
            SKTexture(imageNamed: "water1"),
            SKTexture(imageNamed: "water2")
        ]
        
        let animation = SKAction.animateWithTextures(textures, timePerFrame: 0.3)
        
        _node.runAction(SKAction.repeatActionForever(animation))
        
//        let shader = SKShader(fileNamed: "shader_water.fsh")
//        shader.uniforms = [
//            SKUniform(name: "size", floatVector3: GLKVector3Make(Float(_scene.frame.size.width), Float(_scene.frame.size.height), 0))
//        ]
//        
//        _node.shader = shader
    }
    
    func addToScene () {
        _scene.addChild(_node)
    }
}