//
//  GameScene.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 2/12/16.
//  Copyright (c) 2016 Ilya Shaisultanov. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    private var _background: Background?
    private var _wheelPlacer: WheelPlacer?
    private var _water: Water?
    private var _physicsMgr: PhysicsManager?
    private var _player: Player?
    private var _clouds: Clouds?
    private let _camera = SKCameraNode()
    private var _cameraMovedToPlayer = false
    private var _coin: Coin?
    private var _pin: CoinPin?
    
    private var _gameOverCalled = false
    
    var timeWhenStarted: Double!
    var timeSinceStart: Double!
    
    var LEFT_EDGE: CGFloat!
    var RIGHT_EDGE: CGFloat!
    
    var player: Player? {
        return _player
    }
    
    private var _joint: SKPhysicsJointSpring?
    
    override func didMoveToView(view: SKView) {
        _physicsMgr = PhysicsManager(scene: self)
        
        self.camera = _camera
        camera!.setScale(1)
        
        addChild(_camera)
        
        LEFT_EDGE = self.camera!.position.x - self.size.width / 2
        RIGHT_EDGE = self.camera!.position.x + self.size.width / 2
        
        _wheelPlacer = WheelPlacer(scene: self)
        
        _player = Player(scene: self, physicsManager: _physicsMgr!)
        
        _water = Water(scene: self)
        
        _background = Background(scene: self)
        
        _clouds = Clouds(scene: self)
        
        addChild(_water!)
        
        let scoreLabel = SKLabelNode(text: "10000")
        
        scoreLabel.fontName = "Phatone-Regular"
        scoreLabel.fontSize = 15
        scoreLabel.name = "score"
        scoreLabel.zPosition = 10000
        scoreLabel.position = CGPoint(x: 0, y: frame.height / 2 - 20)
        
        camera?.addChild(scoreLabel)
        
        /** testing out coin **/
        
        _coin = Coin(scene: self, physicsManager: _physicsMgr!)
        _coin!.position = camera!.position
        
        addChild(_coin!)
        
//        _pin = CoinPin(scene: self)
//        _pin?.position = _coin!.position
//        
//        addChild(_pin!)
        
//        _joint = SKPhysicsJointSpring.jointWithBodyA(
//            _coin!.physicsBody!,
//            bodyB: _pin!.physicsBody!,
//            anchorA: _pin!.position,
//            anchorB: _coin!.position
//        )
//        
//        _joint?.damping = 10
        
//        physicsWorld.addJoint(_joint!)
    }
    
    deinit {
        print("DEINIT GAMESCENE")
    }
    
    override func willMoveFromView(view: SKView) {
        print("GAMESCENE WILLMOVEFROMVIEW")
        _wheelPlacer = nil
        _water = nil
        _physicsMgr = nil
        _background = nil
        _clouds = nil
        _player = nil
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        _player?.onTap()

        if _player?.parent == nil {
            for touch in touches {
                placePlayer(touch.locationInNode(self))
            }
        }
    }
    
    func placePlayer (location: CGPoint) {
        let canStart = self.nodesAtPoint(location).filter({ (n) -> Bool in
            if let name = n.name {
                if name.containsString("wheel") {
                    if let wheel = n as? Wheel {
                        return wheel.contains(location)
                    }
                }
            }
            
            return false
        }).isEmpty
        
        if canStart {
            _player?.positionPlayer(location)
        } else {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
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
        _wheelPlacer?.update()
        _background?.update()
        _clouds?.update()
    }
    
    private func _followPlayer() {
        if let player = _player, cam = camera {
            cam.position.y = player.position.y
            return
            
            if let wheel = player.isOnWheel {
                _cameraMovedToPlayer = false
                
                if !cam.hasActions() {
                    let move = SKAction.moveToY(wheel.positionInScene.y, duration: 0.2)
                    
                    cam.runAction(move)
                }
            } else {
                if _cameraMovedToPlayer {
                    cam.position.y = player.position.y
                } else {
                    let move = SKAction.moveToY(player.position.y, duration: 0.1)
                    
                    cam.runAction(move, completion: {
                        cam.position.y = player.position.y
                        self._cameraMovedToPlayer = true
                    })
                }
            }
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
                if player.position.x < LEFT_EDGE || player.position.x > RIGHT_EDGE {
                    player.startDying()
                } else {
                  player.stopDying()
                }
                
                player.normalDamping()
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
