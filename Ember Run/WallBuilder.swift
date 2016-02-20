//
//  WallBuilder.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 2/12/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit

class WallBuilder {
    private enum _WALL_SIDE {
        case LEFT
        case RIGHT
    }
    
    private unowned let _scene: SKScene
    private let _frame_size: CGSize
    
    private var _tiles = [
        _WALL_SIDE.LEFT: [SKSpriteNode](),
        _WALL_SIDE.RIGHT: [SKSpriteNode]()
    ]

    private let _tile_size = UIImage(named: "wall tile")!.size
    
    private var _left_edge: SKPhysicsBody!
    private var _right_edge: SKPhysicsBody!
    
    init(scene: SKScene) {
        self._scene = scene
        _frame_size = scene.size
    }
    
    deinit {
        print("DEINIT WALLBUILDER")
    }
    
    func buildWalls () {
        _populateTiles(.LEFT)
        _populateTiles(.RIGHT)
    }
    
    func update () {
        for side in [_WALL_SIDE.LEFT, .RIGHT] {
            let (start_point, end_point) = _getVerticalBounds(side)
            
            if _tiles[side]!.first!.position.y > start_point.y {
                let tile = _tiles[side]!.removeLast()
                tile.position.y = _tiles[side]!.first!.position.y - _tile_size.height
                _tiles[side]?.insert(tile, atIndex: 0)
            } else if _tiles[side]!.last!.position.y < end_point.y {
                // assuming here there cannot be a situation where both of these are true
                let tile = _tiles[side]!.removeFirst()
                tile.position.y = _tiles[side]!.last!.position.y + _tile_size.height
                _tiles[side]?.append(tile)
            }
        }
    }
    
    private func _populateTiles (side: _WALL_SIDE) {
        let (start_point, end_point) = _getVerticalBounds(side)
        
        var placement = CGPoint(x: start_point.x + WALL_WIDTH/2, y: start_point.y  + _tile_size.height/2)
        
        if let last_tile = _tiles[side]!.last {
            if last_tile.position.y > end_point.y {
                return
            }
            
            placement.y = last_tile.position.y + _tile_size.height
        }
        
        let tile = SKSpriteNode.init(imageNamed: "wall tile")
        
        tile.size = _tile_size
        tile.position = placement
        tile.zPosition = Z.WALL

        self._scene.addChild(tile)
        
        _tiles[side]!.append(tile)
        
        if tile.position.y <= end_point.y {
            _populateTiles(side)
        }
    }
    
    private func _getVerticalBounds (side: _WALL_SIDE) -> (CGPoint, CGPoint) {
        let frame_position = _scene.camera!.position
        
        let x: CGFloat
        
        if side == .LEFT {
            x = _frame_size.width / -2
        } else {
            x = _frame_size.width / 2 - WALL_WIDTH
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