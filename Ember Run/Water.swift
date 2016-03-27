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
        
        super.init(texture: nil /*Water.Texture*/, color: SKColor.clearColor(), size: Water.Texture.size())
        
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
        size = CGSize(width: _scene.frame.width - WALL_WIDTH * 2, height: _scene.frame.height)
        zPosition = Z.WATER
        
        position.x = _scene.LEFT_EDGE + frame.width / 2
        position.y = _scene.camera!.position.y - _scene.size.height * 2
        
        alpha = 0.5
        
        let textures = [
            SKTexture(imageNamed: "water1"),
            SKTexture(imageNamed: "water2")
        ]
        
        let animation = SKAction.animateWithTextures(textures, timePerFrame: 0.3)
        
        runAction(SKAction.repeatActionForever(animation))
        
        //_movement()
    }
    
    private func _movement () {
        let move = SKAction.moveBy(CGVector(dx: 0, dy: 100), duration: 1)
        
        runAction(move) { () -> Void in
            self._movement()
        }
    }
}