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
    fileprivate var _background: Background?
    fileprivate var _clouds: Clouds?
    fileprivate let _camera = SKCameraNode()
    fileprivate var _cameraMovedToPlayer = false
//    private var _coin: Coin?
//    private var _pin: CoinPin?
//    private var _coinPlacer: CoinPlacer?
    fileprivate var _grid: Grid?
    fileprivate var _grid_rendered = false
    fileprivate var _entManager: EntityManager?
    
    fileprivate var _gameOverCalled = false
    
    var timeWhenStarted: Double!
    var timeSinceStart: Double!
    
    var LEFT_EDGE: CGFloat!
    var RIGHT_EDGE: CGFloat!
    let a = WheelEntity(texture: SKTexture(imageNamed: "wheel-1"), size: CGSize(width: 10, height: 10))
    
    fileprivate var _joint: SKPhysicsJointSpring?
    
    override func didMove(to view: SKView) {
        self.camera = _camera
        camera!.setScale(1)
        
        addChild(_camera)
        
        LEFT_EDGE = self.camera!.position.x - self.size.width / 2
        RIGHT_EDGE = self.camera!.position.x + self.size.width / 2
        
        //_water = Water(scene: self)
        
        _background = Background(scene: self)
        
        _clouds = Clouds(scene: self)
        
//        addChild(_water!)
        
        let scoreLabel = SKLabelNode(text: "10000")
        
        scoreLabel.fontName = "Phatone-Regular"
        scoreLabel.fontSize = 15
        scoreLabel.name = "score"
        scoreLabel.zPosition = 10000
        scoreLabel.position = CGPoint(x: 0, y: frame.height / 2 - 20)
        
        camera?.addChild(scoreLabel)
        
//        _coinPlacer = CoinPlacer(scene: self)
//        _coinPlacer?.placeCoins()
        
        /** testing out coin **/
//        
//        _coin = Coin(scene: self)
//        _coin!.position = camera!.position
//        
//        addChild(_coin!)
//        
//        _pin = CoinPin(scene: self)
//        _pin?.position = CGPoint(x: _coin!.position.x + 10.0, y: _coin!.position.y + 10.0)
//        
//        addChild(_pin!)
//        
//        _joint = SKPhysicsJointSpring.jointWithBodyA(
//            _coin!.physicsBody!,
//            bodyB: _pin!.physicsBody!,
//            anchorA: _pin!.position,
//            anchorB: _coin!.position
//        )
//        
//        _joint?.damping = 100
//        _joint?.frequency = 1
//        
//        physicsWorld.addJoint(_joint!)
//        
//        _pin?.position = _coin!.position
        
        /* testing out grid */
        _grid = Grid(rect: frame, scale: 20)
        
        _entManager = EntityManager(scene: self)
        _entManager?.createEntities()
        _entManager?.positionPlayer()
    }
    
    deinit {
        print("DEINIT GAMESCENE")
    }
    
    override func willMove(from view: SKView) {
        print("GAMESCENE WILLMOVEFROMVIEW")
        _entManager = nil
        _background = nil
        _clouds = nil
        _grid = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _entManager?.player.onTap()
    }
    
    override func update(_ currentTime: TimeInterval) {
        _entManager?.update(currentTime)
        
        _background?.update()
        _clouds?.update()

        _followPlayer()
        
        if let dead = _entManager?.player.isDead , dead == true {
            _gameOver()
        }
    }

    override func didApplyConstraints() {
    }
    
    fileprivate func _followPlayer() {
        if let player = _entManager?.player, let cam = camera {
            cam.position.y = player.sprite.position.y
            return
            
            if player.isOnWheel {
                _cameraMovedToPlayer = false
                
//                if !cam.hasActions() {
//                    let move = SKAction.moveToY(wheel.position.y, duration: 0.2)
//                    
//                    cam.runAction(move)
//                }
            } else {
                if _cameraMovedToPlayer {
                    cam.position.y = player.sprite.position.y
                } else {
                    let move = SKAction.moveTo(y: player.sprite.position.y, duration: 0.1)
                    
                    cam.run(move, completion: {
                        cam.position.y = player.sprite.position.y
                        self._cameraMovedToPlayer = true
                    })
                }
            }
        }
    }
    
    fileprivate func _gameOver () {
        if _gameOverCalled {
            return
        }
        
        _gameOverCalled = true
        
        if let gameOver = GameOver(fileNamed: "GameOver") {
            gameOver.scaleMode = .aspectFill
            gameOver.size = self.view!.frame.size
            
            // broken in 9.2
            let transition = SKTransition.crossFade(withDuration: 1)
            view!.presentScene(gameOver, transition: transition)
            
            self.run(SKAction.fadeOut(withDuration: 0.5), completion: {
                self.view!.presentScene(gameOver)
            }) 
        }
    }
    
    fileprivate func _checkPlayerPosition() {
//        if let player = _entManager?.player, pm = _physicsMgr {
//            if let water = _water where player.isInWater(water) {
//                if !player.isDying {
//                    player.highDamping()
//                    player.reduceVelocity()
//                }
//                
//                player.startDying()
//            } else {
////                if player.position.x < LEFT_EDGE || player.position.x > RIGHT_EDGE {
////                    player.startDying()
////                } else {
////                  player.stopDying()
////                }
////                
////                player.normalDamping()
////                pm.setNormalGravity()
//            }
//        }
    }

}
