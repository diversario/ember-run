//
//  Clouds.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 3/16/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Cloud: SKSpriteNode, CustomSprite {
    private var _parentNode: SKEffectNode?
    private var _speed: CGFloat!
    
    var positionInScene: CGPoint!

    private let _cloudType = GKRandomDistribution(lowestValue: 1, highestValue: 4)
    private let _randomAlpha = GKRandomDistribution(lowestValue: 4, highestValue: 10)
    private let _randomVelocity = GKRandomDistribution(lowestValue: 5, highestValue: 30)
    
    init() {
        let texture = SKTexture(imageNamed: "cloud-\(_cloudType.nextInt())")
        let color = SKColor.clearColor()
        let size = texture.size()
        
        super.init(texture: texture, color: color, size: size)
        
        zPosition = Z.CLOUD
        initialize()
        _movement()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initialize (){
        alpha = CGFloat(_randomAlpha.nextInt()) / 10.0
        _speed = CGFloat(self._randomVelocity.nextInt())
    }
    
    func prepareToDie(){
        removeAllActions()
        removeFromParent()
    }
    
    func update() {
        var p: SKEffectNode?
        
        if let _p = parent {
            p = _p as? SKEffectNode
        } else if let _p = _parentNode {
            p = _p
        }
        
        if let p = p, let scene = p.parent as? GameScene {
            if scene.shouldHide(self) {
                _parentNode = p
                self.removeFromParent()
                self.paused = true
            } else if scene.shouldUnide(self) {
                _parentNode?.addChild(self)
                self.paused = false
            }
        }
    }
    
    private func _movement () {
        let move = SKAction.moveBy(CGVector(dx: _speed, dy: 0), duration: 1)
        
        runAction(move) {
            self._movement()
        }
    }
}

class Clouds {
    private var _clouds = [Cloud]()
    private let _frame_size: CGSize
    private unowned let _scene: GameScene
    private let _randomY = GKRandomDistribution(lowestValue: 50, highestValue: 100)
    private let _randomVelocity = GKRandomDistribution(lowestValue: 5, highestValue: 30)
    private let _randomAlpha = GKRandomDistribution(lowestValue: 4, highestValue: 10)
    
    var positionInScene: CGPoint!
    
    init(scene: GameScene) {
        _scene = scene
        _frame_size = scene.size
    }
  
    func update () {
        let max_y = _scene.camera!.position.y + _frame_size.height/2
        
        while _clouds.last?.position.y <= max_y {
            _placeClouds()
        }
        
        for cloud in _clouds {
            if self._scene.shouldRemoveFromScene(cloud) {
                if let idx = self._clouds.indexOf(cloud) {
                    self._clouds.removeAtIndex(idx)
                }
                
                cloud.prepareToDie()
            } else {
                if !self._isCloudVisible(cloud) {
                    cloud.position.x = -self._frame_size.width / 2
                    cloud.initialize()
                }
                
                cloud.update()
            }
        }
    }
    
    private func _placeClouds() {
        var last_cloud: Cloud?
        
        if let _cloud = _clouds.last {
            last_cloud = _cloud
        }
        
        let cloud = Cloud()
        
        let position = CGPoint(
            x: _getRandomX(cloud),
            y: last_cloud != nil ? last_cloud!.position.y + CGFloat(_randomY.nextInt()) : _frame_size.height / -2
        )
        
        cloud.position = position
        cloud.positionInScene = position
        
        _clouds.append(cloud)
        _scene.effect.addChild(cloud)
    }
    
    private func _getRandomX(cloud: SKNode) -> CGFloat {
        let min = Int(WALL_WIDTH + cloud.frame.width / 2 - _frame_size.width / 2)
        let max = Int(_frame_size.width / 2 - WALL_WIDTH - cloud.frame.width / 2)
        
        let rand = GKRandomDistribution(lowestValue: min, highestValue: max)
        
        return CGFloat(rand.nextInt())
    }

    private func _isCloudVisible (cloud: SKSpriteNode) -> Bool {
        return cloud.position.x < _frame_size.width / 2
    }
}