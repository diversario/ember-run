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
    
    private func _setSpriteAttributes () {
        let node = componentForClass(SpriteComponent)!.node
        
        node.zPosition = Z.WHEEL
        node.name = "NAME!!!"// "wheel\(Wheel.WHEEL_COUNT)"
    }
}