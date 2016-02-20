//
//  GameScene.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 2/12/16.
//  Copyright (c) 2016 Ilya Shaisultanov. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    private var _wallBuilder: WallBuilder?
    private var _wheelPlacer: WheelPlacer?
    private var _water: Water?
    private var _physicsMgr: PhysicsManager?
    private var _player: Player?
    
    private var _gameOverCalled = false
    
    var LEFT_EDGE: CGFloat!
    var RIGHT_EDGE: CGFloat!
    
    var player: Player? {
        return _player
    }
    
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
        _wallBuilder?.buildWalls()
        
        _wheelPlacer = WheelPlacer(scene: self)
        
        _player = Player(scene: self, physicsManager: _physicsMgr!)
        
        _water = Water(scene: self)
        _water?.addToScene()
    }
    
    deinit {
        print("DEINIT GAMESCENE")
    }
    
    override func willMoveFromView(view: SKView) {
        print("GAMESCENE WILLMOVEFROMVIEW")
        _wallBuilder = nil
        _wheelPlacer = nil
        _water = nil
        _physicsMgr = nil
        _player = nil
        
        //view.removeFromSuperview()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        _player?.onTap()
        
        for touch in touches {
            let location = touch.locationInNode(self)
            _player?.positionPlayer(location)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        _followPlayer()
        
        if _isPlayerDead() {
            _gameOver()
        }
    }
    
    override func didApplyConstraints() {
        _wallBuilder?.update()
        _wheelPlacer?.update()
    }
    
    private func _followPlayer() {
        if let pos = _player?.position {
            camera?.position = pos
        }

        return
        
        let bottom_edge = camera!.position.y - scene!.frame.size.height / 2
        let top_edge = camera!.position.y + scene!.frame.size.height / 2
        
        let bottom_threshold = bottom_edge + (camera!.position.y - bottom_edge)/2
        let top_threshold = top_edge - (top_edge - camera!.position.y)/2
        
        if _player?.position.y < bottom_threshold {
            camera!.position.y -= 5
        } else if _player?.position.y > top_threshold {
            camera!.position.y += 5
        }
    }
    
    private func _isPlayerDead () -> Bool {
        return _player?.health <= 0
    }
    
    private func _gameOver () {
        if _gameOverCalled {
            return
        }
        
        _gameOverCalled = true
        
        if let gameOver = GameOver(fileNamed: "GameOver") {
            gameOver.scaleMode = .AspectFill
            gameOver.size = self.view!.frame.size
            
            // broken in 9.2
//            let transition = SKTransition.crossFadeWithDuration(1)
//            view!.presentScene(gameOver, transition: transition)
            
            self.runAction(SKAction.fadeOutWithDuration(0.5)) {
                self.view!.presentScene(gameOver)
            }
        }
    }
}
