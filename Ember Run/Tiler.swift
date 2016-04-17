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
    private unowned let _scene: GameScene
    private var _tiles = [SKSpriteNode]()
    
    private let _position: Position
    private let _makeTile: () -> Tile
    
    private let _frame_size: CGSize
    private var _tile_size: CGSize!
    
    init (_ tileMaker: () -> Tile, atPosition position: Position, inScene scene: GameScene) {
        _scene = scene
        _position = position
        
        _makeTile = tileMaker
        
        _frame_size = _scene.size
        
        _populateTiles()
    }
    
    func update () {
        let (start_point, end_point) = _getVerticalBounds()
        
        if _tiles.first!.position.y > start_point.y {
            let tile = _tiles.removeLast()
            tile.position.y = _tiles.first!.position.y - _tile_size.height
            _tiles.insert(tile, atIndex: 0)
        } else if _tiles.last!.position.y < end_point.y {
            // assuming here there cannot be a situation where both of these are true
            let tile = _tiles.removeFirst()
            tile.position.y = _tiles.last!.position.y + _tile_size.height
            _tiles.append(tile)
        }
    }
    
    
    private func _populateTiles () {
        let tile = _makeTile()
        
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
        
        self._scene.effect.addChild(tile)
        
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
            y: frame_position.y - 2.0 * _frame_size.height / 2 - _tile_size.height * 2
        )
        
        let end_point = CGPoint(
            x: start_point.x,
            y: frame_position.y + 2.0 * _frame_size.height / 2 + _tile_size.height * 2
        )
        
        return (start_point, end_point)
    }
}