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
    
    override func didMoveToView(view: SKView) {
        physicsMgr = PhysicsManager(scene: self)
        
        let cam = SKCameraNode()
        self.addChild(cam)
        self.camera = cam
        
        let camConstraint = SKConstraint.positionX(SKRange(constantValue: 0))
        camConstraint.referenceNode = self
        
        self.camera!.constraints = [camConstraint]
        
        wallBuilder = WallBuilder(scene: self)
        wheelPlacer = WheelPlacer(scene: self)
        
        //wallBuilder.setEdges()
        
        player = Player(scene: self, physicsManager: physicsMgr)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        player.onTap()
        for touch in touches {
            let location = touch.locationInNode(self)
            player.positionPlayer(location)
            self.camera!.position = location
        }
    }
   
    override func update(currentTime: CFTimeInterval) {

    }
    
    override func didApplyConstraints() {
        wallBuilder.update()
        wheelPlacer.update()
    }
}
