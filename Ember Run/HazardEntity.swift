//
//  HazardEntity.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 9/12/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class HazardEntity: GKEntity {
    init(size: CGSize, position: CGPoint) {
        super.init()
        
        let texture = SKTexture(imageNamed: "water1")
        let sprite = SpriteComponent(texture: texture, size: size)
        
        sprite.node.zPosition = Z.WATER
        sprite.node.name = "hazard"
        sprite.node.alpha = 0.5
        sprite.node.position = position
        
        addComponent(sprite)
        addActions()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DEINIT HazardEntity")
    }
    
    var edge: CGFloat {
        return sprite.position.y + sprite.size.height / 2
    }
    
    var sprite: SKSpriteNode {
        return component(ofType: SpriteComponent.self)!.node
    }
    
    func addActions () {
        let move = SKAction.move(by: CGVector(dx: 0, dy: 100), duration: 1)
        sprite.run(SKAction.repeatForever(move))
    }
}
