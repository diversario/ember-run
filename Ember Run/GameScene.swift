//
//  GameScene.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 2/12/16.
//  Copyright (c) 2016 Ilya Shaisultanov. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    private var _wallBuilder: WallBuilder!
    private var _wheelPlacer: WheelPlacer!
    private var _water: Water!
    private var _physicsMgr: PhysicsManager!
    private var _player: Player!
    
    var LEFT_EDGE: CGFloat!
    var RIGHT_EDGE: CGFloat!
    
    override func didMoveToView(view: SKView) {
        _physicsMgr = PhysicsManager(scene: self)
        
        let cam = SKCameraNode()
        self.addChild(cam)
        self.camera = cam
        
        LEFT_EDGE = self.camera!.position.x - self.size.width / 2 + WALL_WIDTH
        RIGHT_EDGE = self.camera!.position.x + self.size.width / 2 - WALL_WIDTH
        
        let camConstraint = SKConstraint.positionX(SKRange(constantValue: 0))
        camConstraint.referenceNode = self
        
        self.camera!.constraints = [camConstraint]
        
        _wallBuilder = WallBuilder(scene: self)
        _wallBuilder.buildWalls()
        
        _wheelPlacer = WheelPlacer(scene: self)
        
        _player = Player(scene: self, physicsManager: _physicsMgr)
        
        _water = Water(scene: self)
        _water.addToScene()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        _player.onTap()
        
        for touch in touches {
            let location = touch.locationInNode(self)
            _player.positionPlayer(location)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        _followPlayer()
    }
    
    override func didApplyConstraints() {
        _wallBuilder.update()
        _wheelPlacer.update()
    }
    
    private func _followPlayer() {
        camera!.position = _player.position
        return
        
        let bottom_edge = camera!.position.y - scene!.frame.size.height / 2
        let top_edge = camera!.position.y + scene!.frame.size.height / 2
        
        let bottom_threshold = bottom_edge + (camera!.position.y - bottom_edge)/2
        let top_threshold = top_edge - (top_edge - camera!.position.y)/2
        
        if _player.position.y < bottom_threshold {
            camera!.position.y -= 5
        } else if _player.position.y > top_threshold {
            camera!.position.y += 5
        }
    }
}
