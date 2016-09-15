//
//  SpriteComponent.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 8/20/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {
    let node: SKSpriteNode
    
    init(texture: SKTexture, color: SKColor, size: CGSize) {
        node = SKSpriteNode(texture: texture, color: color, size: size)
    }
    
    convenience init(texture: SKTexture, size: CGSize) {
        self.init(texture: texture, color: SKColor.clearColor(), size: size)
    }
    
    deinit {
        print("DEINIT SpriteComponent")
    }
}
