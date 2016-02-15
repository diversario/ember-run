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
    enum WALL_SIDE {
        case LEFT
        case RIGHT
    }
    
    let scene: SKScene
    let frame_size: CGSize
    
    var tiles = [
        WALL_SIDE.LEFT: [SKSpriteNode](),
        WALL_SIDE.RIGHT: [SKSpriteNode]()
    ]

    let tile_size = UIImage(named: "wall tile")!.size
    
    var left_edge: SKPhysicsBody!
    var right_edge: SKPhysicsBody!
    
    init(scene: SKScene) {
        self.scene = scene
        frame_size = scene.size
    }
    
    func update () {
        populateTiles(.LEFT)
        populateTiles(.RIGHT)
    }
    
    func populateTiles (side: WALL_SIDE) {
        let frame_position = scene.camera!.position

        let x: CGFloat
        
        if side == .LEFT {
            x = frame_size.width / -2
        } else {
            x = frame_size.width / 2 - WALL_WIDTH
        }
        
        let start_point = CGPoint(
            x: frame_position.x + x,
            y: frame_position.y - frame_size.height / 2
        )

        let end_point = CGPoint(
            x: start_point.x,
            y: frame_position.y + frame_size.height / 2
        )
        
        var placement = CGPoint(x: start_point.x + WALL_WIDTH/2, y: start_point.y  + tile_size.height/2)
        
        if let last_tile = tiles[side]!.last {
            if last_tile.position.y > end_point.y {
                return
            }
            
            placement.y = last_tile.position.y + tile_size.height
        }
        
        let tile = SKSpriteNode.init(imageNamed: "wall tile")
        tile.size = tile_size
        tile.position = placement
        
        self.scene.addChild(tile)
        
        tiles[side]!.append(tile)
        
        if tile.position.y <= end_point.y {
            populateTiles(side)
        }
    }
    
    func setEdges() {
        let frame_position = scene.camera!.position
        
        let left_x = frame_position.x - frame_size.width / 2 + WALL_WIDTH
        let right_x = frame_position.x + frame_size.width / 2 - WALL_WIDTH
        
        let top_y = frame_position.y + frame_size.height
        let bottom_y = frame_position.y - frame_size.height
        
        let rect = CGRect(x: left_x, y: bottom_y, width: right_x - left_x, height: top_y - bottom_y)
        
        scene.physicsBody = SKPhysicsBody(edgeLoopFromRect: rect)
        scene.physicsBody!.affectedByGravity = false
        scene.physicsBody!.dynamic = false
        scene.physicsBody!.contactTestBitMask = PhysicsManager.bodies.walls | PhysicsManager.bodies.player
    }
}