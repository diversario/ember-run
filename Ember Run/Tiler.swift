//
//  Tiler.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 3/7/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit

public enum Position : Int {
    case LEFT
    case RIGHT
    case CENTER
}

class Tiler {
    private unowned let _scene: SKScene
    private var _tiles = [SKSpriteNode]()
    
    private let _position: Position
    private let _texture: SKTexture
    
    private let _frame_size: CGSize
    
    init (_ imageNamed: String, atPosition position: Position, inScene scene: SKScene) {
        _scene = scene
        _position = position
        _texture = SKTexture(imageNamed: imageNamed)
        
        _frame_size = _scene.size
    }
    
    
}