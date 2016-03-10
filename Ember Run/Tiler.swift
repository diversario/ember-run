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
    private let _Tile: () -> Tile
    
    private let _frame_size: CGSize
    private var _tile_size: CGSize!
    
    init (_ type: () -> Tile, atPosition position: Position, inScene scene: SKScene) {
        _scene = scene
        _position = position
        
        _Tile = type
        
        _frame_size = _scene.size
    }
    
    func update () {
        _populateTiles()
    }
    
    
    private func _populateTiles () {
        let tile = _Tile()
        
        if _tile_size == nil {
            _tile_size = tile.tileSize
        }
        
        let (start_point, end_point) = _getVerticalBounds()
        
        var placement = CGPoint(x: start_point.x + _tile_size.width/2, y: start_point.y  + _tile_size.height/2)
        
        if let last_tile = _tiles.last {
            if last_tile.position.y > end_point.y {
                return
            }
            
            placement.y = last_tile.position.y + _tile_size.height
        }
        
        
        tile.position = placement
        
        self._scene.addChild(tile)
        
        _tiles.append(tile)
        
        if tile.position.y <= end_point.y {
            _populateTiles()
        }
    }

    private func _getVerticalBounds () -> (CGPoint, CGPoint) {
        let frame_position = _scene.camera!.position
        
        let x: CGFloat
        
        switch _position {
            case .LEFT:
                x = _frame_size.width / -2
            case .RIGHT:
                x = _frame_size.width / 2 - _tile_size.width
            case .CENTER:
                x = 0 - _tile_size.width / 2
        }
        
        let start_point = CGPoint(
            x: frame_position.x + x,
            y: frame_position.y - _frame_size.height / 2 - _tile_size.height * 2
        )
        
        let end_point = CGPoint(
            x: start_point.x,
            y: frame_position.y + _frame_size.height / 2 + _tile_size.height * 2
        )
        
        return (start_point, end_point)
    }
}