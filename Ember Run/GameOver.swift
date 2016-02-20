//
//  GameOver.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 2/19/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit

class GameOver: SKScene {
    override func didMoveToView(view: SKView) {
        print("GAMEOVER DIDMOVETOVIEW")
        
        self.alpha = 0
        
        let label = SKLabelNode(text: "Game Over")
        label.position = CGPoint(x: CGRectGetMidX(scene!.frame), y:  CGRectGetMidY(scene!.frame))
        
        label.zPosition = 600
        self.addChild(label)
        
        self.runAction(SKAction.fadeInWithDuration(1.0))
    }
    
    deinit {
        print("DEINIT GAMEOVER")
    }
    
    override func willMoveFromView(view: SKView) {
        view.removeFromSuperview()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view?.presentScene(nil)
    }
}