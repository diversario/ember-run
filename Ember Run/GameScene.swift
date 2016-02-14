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
        
        wheelPlacer.update()
        /* Setup your scene here */
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!"
//        myLabel.fontSize = 45
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
//        
//        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            wheelPlacer.wheels[1].position = location
            
            print("LOCATION", location)
            
            let dist = wheelPlacer.spaceBetweenCircles(
                wheelPlacer.wheels[0],
                wheelPlacer.wheels[1]
            )

            print("DISTANCE BETWEEN EDGES", dist)
            
            //self.camera!.position = location
            
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
        wallBuilder.update()
    }
}
