//
//  TileProtocol.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 3/8/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit

protocol TileSize {
    var tileSize: CGSize {get}
}

class Tile: SKSpriteNode {
    private var _texture: SKTexture!
    
    var tileSize: CGSize {
        return _texture.size()
    }
    
    init(t: SKTexture, c: SKColor, s: CGSize) {
        super.init(texture: t, color: c, size: s)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
