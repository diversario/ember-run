//
//  GameScene.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 2/12/16.
//  Copyright (c) 2016 Ilya Shaisultanov. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    private var _wallBuilder: Wall?
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
        
        _wallBuilder = Wall(scene: self)
        _wallBuilder?.buildWalls()
        
        _wheelPlacer = WheelPlacer(scene: self)
        
        _player = Player(scene: self, physicsManager: _physicsMgr!)
        
        _water = Water(scene: self)
        addChild(_water!)
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
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        _player?.onTap()
        

        
        for touch in touches {
            let location = touch.locationInNode(self)
            _player?.positionPlayer(location)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        self._checkPlayerPosition()
        
        _player?.syncParticles()
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
    
    private func _checkPlayerPosition() {
        if let player = player, water = _water, pm = _physicsMgr {
            if player.isInWater(water) {
                if !player.isDying {
                    player.highDamping()
                    player.reduceVelocity()
                    
                    pm.setInWaterGravity()
                }
                
                player.startDying()
            } else {
                player.normalDamping()
                
                player.stopDying()
                
                pm.setNormalGravity()
            }
            
        }

    }
}
