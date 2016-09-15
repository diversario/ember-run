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
    override func didMove(to view: SKView) {
        print("GAMEOVER DIDMOVETOVIEW")
        
        self.alpha = 0
        
        let label = SKLabelNode(text: "Game Over")
        label.position = CGPoint(x: scene!.frame.midX, y:  scene!.frame.midY)
        
        label.zPosition = 600
        self.addChild(label)
        
        self.run(SKAction.fadeIn(withDuration: 1.0))
    }
    
    deinit {
        print("DEINIT GAMEOVER")
    }
    
    override func willMove(from view: SKView) {
        view.removeFromSuperview()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view?.presentScene(nil)
    }
}
