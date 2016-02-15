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
    
    override func didMoveToView(view: SKView) {
        let cam = SKCameraNode()
        self.addChild(cam)
        self.camera = cam
        
        let camConstraint = SKConstraint.positionX(SKRange(constantValue: 0))
        camConstraint.referenceNode = self
        
        self.camera!.constraints = [camConstraint]
        
        wallBuilder = WallBuilder(scene: self)
        wheelPlacer = WheelPlacer(scene: self)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            self.camera!.position = location
            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {

    }
    
    override func didApplyConstraints() {
        wallBuilder.update()
        wheelPlacer.update()
    }
}
