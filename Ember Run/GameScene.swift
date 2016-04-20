//
//  GameScene.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 2/12/16.
//  Copyright (c) 2016 Ilya Shaisultanov. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    private var _background: Background?
    private var _wallBuilder: Wall?
    private var _wheelPlacer: WheelPlacer?
    private var _water: Water?
    private var _physicsMgr: PhysicsManager?
    private var _player: Player?
    private var _clouds: Clouds?
    private let _camera = SKCameraNode()
    private let _camConstraint = SKConstraint.positionX(SKRange(constantValue: 0))
    
    private var _gameOverCalled = false
    
    var timeWhenStarted: Double!
    var timeSinceStart: Double!
    
    var LEFT_EDGE: CGFloat!
    var RIGHT_EDGE: CGFloat!
    
    var player: Player? {
        return _player
    }
    
    override func didMoveToView(view: SKView) {
        _physicsMgr = PhysicsManager(scene: self)
        
        self.camera = _camera
        camera!.setScale(1)
        
        LEFT_EDGE = self.camera!.position.x - self.size.width / 2 + WALL_WIDTH
        RIGHT_EDGE = self.camera!.position.x + self.size.width / 2 - WALL_WIDTH
        
        _camConstraint.referenceNode = self
        
        self.camera!.constraints = [_camConstraint]
        
        _wallBuilder = Wall(scene: self)
        _wallBuilder?.buildWalls()
        
        _wheelPlacer = WheelPlacer(scene: self)
        
        _player = Player(scene: self, physicsManager: _physicsMgr!)
        
        _water = Water(scene: self)
        
        _background = Background(scene: self)
        
        _clouds = Clouds(scene: self)
        
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
        _background = nil
        _clouds = nil
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
        // water position is time-based
        if timeWhenStarted == nil {
            timeWhenStarted = currentTime - Double(frame.size.height/3)
        }
        
        timeSinceStart = currentTime - timeWhenStarted

        _water?.position.y += CGFloat(abs(timeSinceStart)/100)
        
        self._checkPlayerPosition()

        _followPlayer()
        
        if _isPlayerDead() {
            _gameOver()
        }
    }
    
    override func didApplyConstraints() {
        _wallBuilder?.update()
        _wheelPlacer?.update()
        _background?.update()
        _clouds?.update()
    }
    
    private func _followPlayer() {
        if let pos = _player?.position {
            _camera.position = pos
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
    
    func shouldRemoveFromScene (node: CustomSprite) -> Bool {
        if let water = _water {
            return node.positionInScene.y < (water.position.y - water.size.height/2)
        }
        
        return false
    }
    
    func shouldHide (node: CustomSprite) -> Bool {
        let pos = node.positionInScene
        
        return node.parent != nil &&
               pos.y < (camera!.position.y - frame.size.height) ||
               pos.y > (camera!.position.y + frame.size.height)
    }
    
    func shouldUnide (node: CustomSprite) -> Bool {
        let pos = node.positionInScene
        
        return node.parent == nil &&
            pos.y > (camera!.position.y - frame.size.height) &&
            pos.y < (camera!.position.y + frame.size.height)
    }
}
