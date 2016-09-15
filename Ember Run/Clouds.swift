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
//private func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l < r
//  case (nil, _?):
//    return true
//  default:
//    return false
//  }
//}
//
//private func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l <= r
//  default:
//    return !(rhs < lhs)
//  }
//}


class Cloud: SKSpriteNode {
    private var _parentNode: GameScene?
    private var _speed: CGFloat!
    
    private let _cloudType = GKRandomDistribution(lowestValue: 1, highestValue: 4)
    private let _randomAlpha = GKRandomDistribution(lowestValue: 4, highestValue: 10)
    private let _randomVelocity = GKRandomDistribution(lowestValue: 5, highestValue: 30)
    
    init() {
        let texture = SKTexture(imageNamed: "cloud-\(_cloudType.nextInt())")
        let color = SKColor.clear
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
        var scene: GameScene?
        
        if let _p = parent as? GameScene {
            scene = _p
        } else if let _p = _parentNode {
            scene = _p
        }
        
//        if let scene = scene {
//            if scene.shouldHide(self) {
//                _parentNode = scene
//                self.removeFromParent()
//                self.paused = true
//            } else if scene.shouldUnide(self) {
//                _parentNode?.addChild(self)
//                self.paused = false
//            }
//        }
    }
    
    private func _movement () {
        let move = SKAction.move(by: CGVector(dx: _speed, dy: 0), duration: 1)
        
        run(move, completion: {
            self._movement()
        }) 
    }
}

class Clouds {
    private var _clouds = [Cloud]()
    private let _frame_size: CGSize
    private unowned let _scene: GameScene
    private let _randomY = GKRandomDistribution(lowestValue: 50, highestValue: 100)
    private let _randomVelocity = GKRandomDistribution(lowestValue: 5, highestValue: 30)
    private let _randomAlpha = GKRandomDistribution(lowestValue: 4, highestValue: 10)
    
    init(scene: GameScene) {
        _scene = scene
        _frame_size = scene.size
    }
  
    func update () {
        let max_y = _scene.camera!.position.y + _frame_size.height/2
        
        while let y = _clouds.last?.position.y, y <= max_y {
            _placeClouds()
        }
        
        // this is repeated in WheelPlacer, can be broken out, maybe
        for cloud in _clouds {
//            if self._scene.shouldRemoveFromScene(cloud) {
//                if let idx = self._clouds.indexOf(cloud) {
//                    self._clouds.removeAtIndex(idx)
//                }
//                
//                cloud.prepareToDie()
//            } else {
//                if !self._isCloudVisible(cloud) {
//                    cloud.position.x = -self._frame_size.width / 2
//                    cloud.initialize()
//                }
//                
//                cloud.update()
//            }
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
        
        _clouds.append(cloud)
        _scene.addChild(cloud)
    }
    
    private func _getRandomX(_ cloud: SKNode) -> CGFloat {
        let min = Int(0 - cloud.frame.width - _frame_size.width / 2)
        let max = Int(_frame_size.width / 2 + cloud.frame.width)
        
        let rand = GKRandomDistribution(lowestValue: min, highestValue: max)
        
        return CGFloat(rand.nextInt())
    }

    private func _isCloudVisible (_ cloud: SKSpriteNode) -> Bool {
        return cloud.position.x < _frame_size.width / 2
    }
}
