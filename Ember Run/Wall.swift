//
//  Wall.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 2/12/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit


func tileMaker (side: Side) -> () -> Tile {
    func makeTile () -> Tile {
        return WallTile(side: side)
    }
    
    return makeTile
}


class Wall {
    private enum _WALL_SIDE {
        case LEFT
        case RIGHT
    }
    
    private unowned let _scene: SKScene
    private let _frame_size: CGSize
    
    private var _tiles = [_WALL_SIDE: Tiler]()
    
    init(scene: SKScene) {
        self._scene = scene
        _frame_size = scene.size
        
        _tiles[_WALL_SIDE.LEFT] = Tiler(tileMaker(.LEFT), atPosition: Position.LEFT, inScene: _scene)
        _tiles[_WALL_SIDE.RIGHT] = Tiler(tileMaker(.RIGHT), atPosition: Position.RIGHT, inScene: _scene)
    }
    
    deinit {
        print("DEINIT WALL")
    }
    
    func buildWalls () {
    }
    
    func update () {
        _tiles[_WALL_SIDE.LEFT]!.update()
        _tiles[_WALL_SIDE.RIGHT]!.update()
    }
}