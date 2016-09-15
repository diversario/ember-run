//
//  WheelPhysicsComponent.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 8/22/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class WheelPhysicsComponent: GKComponent {
    init (sprite: SKSpriteNode, radius: CGFloat) {
        super.init()
        
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: radius - 1)
        
        let body = sprite.physicsBody!
    
        body.affectedByGravity = false
        body.isDynamic = false
        body.contactTestBitMask = CONTACT_MASK.WHEEL
        body.collisionBitMask = COLLISION_MASK.WHEEL
        body.categoryBitMask = CAT.WHEEL
        body.usesPreciseCollisionDetection = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DEINIT WheelPhysicsComponent")
    }
}
