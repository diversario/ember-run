//
//  GameScene.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 2/12/16.
//  Copyright (c) 2016 Ilya Shaisultanov. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let effect = SKEffectNode()
    
    private var _background: Background?
    private var _wallBuilder: Wall?
    private var _wheelPlacer: WheelPlacer?
    private var _water: Water?
    private var _physicsMgr: PhysicsManager?
    private var _player: Player?
    private var _clouds: Clouds?
    
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

        let cam = SKCameraNode()
        cam.setScale(4)
        self.effect.addChild(cam)
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
        
        _background = Background(scene: self)
        
        _clouds = Clouds(scene: self)
        
        effect.addChild(_water!)
        
        let shader = SKShader(fileNamed: "shader_water.fsh")
        
        shader.uniforms = [
            SKUniform(name: "test", float: Float(_player!.position.y))
        ]
        
        addChild(effect)
        
        //effect.shader = shader
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
        if timeWhenStarted == nil {
            timeWhenStarted = currentTime
        }
        
        timeSinceStart = currentTime - timeWhenStarted
        
//        let marker = SKShapeNode(circleOfRadius: 2)
//        marker.strokeColor = SKColor.clearColor()
//        marker.fillColor = SKColor.blackColor()
//        
//        marker.position = camera!.position
//        marker.zPosition = 10000
//        effect.addChild(marker)
        
        self._checkPlayerPosition()
        //print(timeSinceStart)
        //_water?.position.y = CGFloat(timeSinceStart)
//        _player?.syncParticles()
         _followPlayer()
        
        if _isPlayerDead() {
            _gameOver()
        }
        
        effect.shader?.uniformNamed("test")?.floatValue = Float(timeSinceStart)
    }
    
    override func didApplyConstraints() {
        _wallBuilder?.update()
        _wheelPlacer?.update()
        _background?.update()
        _clouds?.update()
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
