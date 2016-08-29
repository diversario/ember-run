//
//  WheelEntity.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 8/20/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class WheelEntity: GKEntity {
    let radius: CGFloat
    
    var velocity: CGFloat {
        let node = componentForClass(SpriteComponent)!.node
        return node.physicsBody!.angularVelocity
    }
    
    var direction: ROTATION_DIRECTION {
        return componentForClass(WheelRotationComponent)!.direction
    }
    
    init(texture: SKTexture, size: CGSize) {
        radius = size.height / 2
        
        let sprite = SpriteComponent(texture: texture, size: size)
        let rotation = WheelRotationComponent(sprite: sprite.node)
        let physics = WheelPhysicsComponent(sprite: sprite.node, radius: radius)
        
        super.init()
        
        addComponent(physics)
        addComponent(sprite)
        addComponent(rotation)
        
        _setSpriteAttributes()
    }
    
    convenience init(randomRadius: GKRandomDistribution) {
        let radius = CGFloat(randomRadius.nextInt())
        let texture = WheelEntity._getWheelTexture(radius, min: randomRadius.lowestValue, max: randomRadius.highestValue)
        let size = CGSize(width: radius, height: radius)
        
        self.init(texture: texture, size: size)
    }
    
    private func _setSpriteAttributes () {
        let node = componentForClass(SpriteComponent)!.node
        
        node.zPosition = Z.WHEEL
        node.name = "NAME!!!"// "wheel\(Wheel.WHEEL_COUNT)"
    }
    
    private static func _getWheelTexture (radius: CGFloat, min: Int, max: Int) -> SKTexture {
        let step = CGFloat(max - min) / 4.0 // 5 wheels. Should be programmatic tho
        let num = radius - CGFloat(min)
        let texture_num = round(num / step) + 1
        
        return SKTexture(imageNamed: "wheel-\(texture_num)")
    }
}