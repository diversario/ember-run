//
//  WallTile.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 3/5/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit

public enum Side {
    case LEFT
    case RIGHT
}

class WallTile: Tile {
    init (side: Side) {
        let texture: SKTexture
        
        if side == .LEFT {
            texture = SKTexture(imageNamed: "wall-tile-left")
        } else {
            texture = SKTexture(imageNamed: "wall-tile-right")
        }
        
        super.init(t: texture, c: SKColor.clearColor(), s: texture.size())
        
        _setAttributes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func _setAttributes () {
        zPosition = Z.WALL
        alpha = 1
    }
}