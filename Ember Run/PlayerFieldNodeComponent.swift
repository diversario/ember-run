//
//  PlayerFieldNodeComponent.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 8/31/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class PlayerFieldNodeComponent: GKComponent {
    init (sprite: SKSpriteNode) {
        sprite.physicsBody!.fieldBitMask = CAT.PLAYER
        
        let fieldNode = SKFieldNode.springField()
        fieldNode.strength = 100
        fieldNode.categoryBitMask = CAT.COIN
        fieldNode.region = SKRegion(radius: Float((sprite.size.width/2) * 6))
        
        sprite.addChild(fieldNode)
    }
}