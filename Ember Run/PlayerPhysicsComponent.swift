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

class PlayerPhysicsComponent: GKComponent {
    init (sprite: SKSpriteNode) {
        super.init()
        
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width/2)
        sprite.physicsBody!.contactTestBitMask = CONTACT_MASK.PLAYER
        sprite.physicsBody!.collisionBitMask = COLLISION_MASK.PLAYER
        sprite.physicsBody!.categoryBitMask = CAT.PLAYER
        
        sprite.physicsBody!.usesPreciseCollisionDetection = false
        
        sprite.physicsBody!.mass = 0.01 * SCREEN_SCALE
        
        sprite.physicsBody!.fieldBitMask = CAT.PLAYER
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DEINIT PlayerPhysicsComponent")
    }
}
