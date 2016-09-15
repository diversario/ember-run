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
    var node: SKSpriteNode
    
    init(texture: SKTexture, color: SKColor, size: CGSize) {
        node = SKSpriteNode(texture: texture, color: color, size: size)
        super.init()
    }
    
    convenience init(texture: SKTexture, size: CGSize) {
        self.init(texture: texture, color: SKColor.clear, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DEINIT SpriteComponent")
    }
}
