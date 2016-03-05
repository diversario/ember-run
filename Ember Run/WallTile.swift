//
//  WallTile.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 3/5/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit

class WallTile: SKSpriteNode {
    private static let Texture = SKTexture(imageNamed: "wall tile")
    static let TILE_SIZE = WallTile.Texture.size()
    
    convenience init(atPosition position: CGPoint) {
        self.init()
        self.position = position
    }
    
    init () {
        super.init(texture: WallTile.Texture, color: SKColor.clearColor(), size: WallTile.TILE_SIZE)
        
        _setAttributes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func _setAttributes () {
        zPosition = Z.WALL
        alpha = 0.5
    }
}