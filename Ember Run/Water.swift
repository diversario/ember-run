//
//  Water.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 3/6/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit

class Water: SKSpriteNode {
    private unowned var _scene: GameScene
    
    private static let Texture = SKTexture(imageNamed: "water1")
    
    var waterline: CGFloat {
        return position.y + size.height / 2
    }
    
    init (scene: GameScene) {
        _scene = scene
        
        super.init(texture: Water.Texture, color: SKColor.clearColor(), size: Water.Texture.size())
        
        _setAttributes()
    }
    
    deinit {
        print("DEINIT PLAYER")
    }
    
    required init?(coder aDecoder: NSCoder) {
        _scene = GameScene(fileNamed: "GameScene")!
        
        super.init(coder: aDecoder)
    }
    
    private func _setAttributes () {
        size = CGSize(width: _scene.frame.width - WALL_WIDTH * 2, height: _scene.frame.height * 2)
        zPosition = Z.WATER
        
        position.x = _scene.LEFT_EDGE + frame.width / 2
        position.y = _scene.camera!.position.y - _scene.size.height * 2
        
        alpha = 0.5
        
//        physicsBody = SKPhysicsBody(rectangleOfSize: _node.frame.size)
//        physicsBody!.contactTestBitMask = CONTACT_MASK.WATER
//        physicsBody!.collisionBitMask = COLLISION_MASK.WATER
//        physicsBody!.categoryBitMask = CAT.WATER
//        physicsBody!.dynamic = false
        
        let textures = [
            SKTexture(imageNamed: "water1"),
            SKTexture(imageNamed: "water2")
        ]
        
        let animation = SKAction.animateWithTextures(textures, timePerFrame: 0.3)
        
        runAction(SKAction.repeatActionForever(animation))
        
        //        let shader = SKShader(fileNamed: "shader_water.fsh")
        //        shader.uniforms = [
        //            SKUniform(name: "size", floatVector3: GLKVector3Make(Float(_scene.frame.size.width), Float(_scene.frame.size.height), 0))
        //        ]
        //
        //        _node.shader = shader
        
        _movement()
    }
    
    private func _movement () {
        let move = SKAction.moveBy(CGVector(dx: 0, dy: 100), duration: 1)
        
        runAction(move) { () -> Void in
            self._movement()
        }
    }
}