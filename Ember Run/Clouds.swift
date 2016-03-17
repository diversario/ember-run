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

class Clouds {
    private var _clouds = [SKSpriteNode]()
    private let _frame_size: CGSize
    private unowned let _scene: SKScene
    private let _cloudType = GKRandomDistribution(lowestValue: 1, highestValue: 4)
    private let _randomY = GKRandomDistribution(lowestValue: 10, highestValue: 50)
    private let _randomVelocity = GKRandomDistribution(lowestValue: 5, highestValue: 50)
    private let _randomAlpha = GKRandomDistribution(lowestValue: 4, highestValue: 10)
    
    init(scene: SKScene) {
        _scene = scene
        _frame_size = scene.size
    }
    
    func update () {
        let max_y = _scene.camera!.position.y + _frame_size.height/2
        
        while _clouds.last?.position.y <= max_y {
            _placeClouds()
        }
    }
    
    private func _placeClouds() {
        var last_cloud: SKSpriteNode?
        
        if let _cloud = _clouds.last {
            last_cloud = _cloud
        }
        
        let cloud = SKSpriteNode(imageNamed: "cloud-\(_cloudType.nextInt())")
        
        let position = CGPoint(
            x: _getRandomX(cloud),
            y: last_cloud != nil ? last_cloud!.position.y + CGFloat(_randomY.nextInt()) : _frame_size.height / -2
        )
        
        cloud.position = position
        cloud.zPosition = Z.CLOUD
        cloud.alpha = CGFloat(_randomAlpha.nextInt()) / 10.0
        
        let speed = CGFloat(_randomVelocity.nextInt())
        
        _movement(cloud, speed: speed)
        
        _clouds.append(cloud)
        _scene.addChild(cloud)
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
    
    private func _movement (cloud: SKSpriteNode, speed: CGFloat) {
        let move = SKAction.moveBy(CGVector(dx: speed, dy: 0), duration: 1)
        
        cloud.runAction(move) { _ in
            if self._isCloudVisible(cloud) {
                self._movement(cloud, speed: speed)
            } else {
                if let idx = self._clouds.indexOf(cloud) {
                    self._clouds.removeAtIndex(idx)
                }
            }
        }

    }
}