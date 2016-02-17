//
//  GameScene.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 2/12/16.
//  Copyright (c) 2016 Ilya Shaisultanov. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var wallBuilder: WallBuilder!
    var wheelPlacer: WheelPlacer!
    var physicsMgr: PhysicsManager!
    var player: Player!
    
    var LEFT_EDGE: CGFloat!
    var RIGHT_EDGE: CGFloat!
    
    override func didMoveToView(view: SKView) {
        physicsMgr = PhysicsManager(scene: self)
        
        let cam = SKCameraNode()
        self.addChild(cam)
        self.camera = cam
        
        LEFT_EDGE = self.camera!.position.x - self.size.width / 2 + WALL_WIDTH
        RIGHT_EDGE = self.camera!.position.x + self.size.width / 2 - WALL_WIDTH
        
        let camConstraint = SKConstraint.positionX(SKRange(constantValue: 0))
        camConstraint.referenceNode = self
        
        self.camera!.constraints = [camConstraint]
        
        wallBuilder = WallBuilder(scene: self)
        wheelPlacer = WheelPlacer(scene: self)
        
        player = Player(scene: self, physicsManager: physicsMgr)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        player.onTap()
        for touch in touches {
            let location = touch.locationInNode(self)
            player.positionPlayer(location)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        self.camera!.position = player.node.position
    }
    
    override func didApplyConstraints() {
        wallBuilder.update()
        wheelPlacer.update()
    }
}
