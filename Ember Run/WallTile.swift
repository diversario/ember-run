//
//  WallTile.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 3/5/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit

class WallTile: Tile {
    init () {
        let texture = SKTexture(imageNamed: "wall tile")
        super.init(t: texture, c: SKColor.clearColor(), s: texture.size())
        
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