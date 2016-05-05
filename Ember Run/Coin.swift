//
//  Coin.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 4/23/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit

class Coin: SKSpriteNode, CustomSprite {
    private var _parentNode: GameScene?
    
    override var position: CGPoint {
        willSet {
            positionInScene = newValue
        }
    }
    
    var positionInScene: CGPoint!

    private static let Texture = SKTexture(imageNamed: "coin")
    
    private unowned let _scene: GameScene
    private unowned let _physicsManager: PhysicsManager

    init (scene: GameScene, physicsManager: PhysicsManager) {
        _scene = scene
        _physicsManager = physicsManager
        
        super.init(texture: Coin.Texture, color: SKColor.clearColor(), size: Coin.Texture.size())
        
        _setAttributes()
    }
    
    deinit {
        print("DEINIT COIN")
    }
    
    required init?(coder aDecoder: NSCoder) {
        _scene = GameScene(fileNamed: "GameScene")!
        _physicsManager = PhysicsManager(scene: _scene)
        
        super.init(coder: aDecoder)
    }
    
    private func _setAttributes () {
        name = "coin"
        
        zPosition = Z.COIN
        
        physicsBody = SKPhysicsBody(circleOfRadius: Coin.Texture.size().height)
        physicsBody!.mass = 1//20// 0.01 * SCREEN_SCALE // maybe not needed
        //physicsBody!.density = 0
        physicsBody!.affectedByGravity = false
        physicsBody!.linearDamping = 1
        physicsBody!.restitution = 0
        physicsBody!.fieldBitMask = CAT.COIN
        
        physicsBody!.categoryBitMask = CAT.COIN
        physicsBody!.collisionBitMask = COLLISION_MASK.COIN
        physicsBody!.contactTestBitMask = CONTACT_MASK.COIN
    }
    
    func prepareToDie () {
        removeFromParent()
        removeAllActions()
    }
    
    func update() {
        var scene: GameScene?
        
        if let _p = parent as? GameScene {
            scene = _p
        } else if let _p = _parentNode {
            scene = _p
        }
        
        if let scene = scene {
            if scene.shouldHide(self) {
                _parentNode = scene
                self.removeFromParent()
                self.paused = true
            } else if scene.shouldUnide(self) {
                scene.addChild(self)
                self.paused = false
            }
        }
    }
}