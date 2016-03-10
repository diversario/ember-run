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
    private var _texture: SKTexture! = SKTexture(imageNamed: "wall tile")
    
    override var tileSize: CGSize {
        return _texture.size()
    }
    
    convenience init(atPosition position: CGPoint) {
        self.init()
        self.position = position
    }
    
    init () {
        super.init(t: _texture, c: SKColor.clearColor(), s: _texture.size())
        
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