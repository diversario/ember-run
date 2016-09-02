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
    private var _physicsMgr: PhysicsEntity?
    private var _player: Player?
    private var _clouds: Clouds?
    private let _camera = SKCameraNode()
    private var _cameraMovedToPlayer = false
//    private var _coin: Coin?
//    private var _pin: CoinPin?
//    private var _coinPlacer: CoinPlacer?
    private var _grid: Grid?
    private var _grid_rendered = false
    private var _entManager: EntityManager?
    
    private var _gameOverCalled = false
    
    var timeWhenStarted: Double!
    var timeSinceStart: Double!
    
    var LEFT_EDGE: CGFloat!
    var RIGHT_EDGE: CGFloat!
    let a = WheelEntity(texture: SKTexture(imageNamed: "wheel-1"), size: CGSize(width: 10, height: 10))
    var player: Player? {
        return _player
    }
    
    private var _joint: SKPhysicsJointSpring?
    
    override func didMoveToView(view: SKView) {
        _physicsMgr = PhysicsEntity(scene: self)
        
        self.camera = _camera
        camera!.setScale(1)
        
        addChild(_camera)
        
        LEFT_EDGE = self.camera!.position.x - self.size.width / 2
        RIGHT_EDGE = self.camera!.position.x + self.size.width / 2
        
        _wheelPlacer = WheelPlacer(scene: self)
        
        _player = Player(scene: self, physicsManager: _physicsMgr!)
        
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
    
    override func willMoveFromView(view: SKView) {
        print("GAMESCENE WILLMOVEFROMVIEW")
        _wheelPlacer = nil
        _water = nil
        _physicsMgr = nil
        _background = nil
        _clouds = nil
        _player = nil
        _grid = nil
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        _entManager?.player.onTap()
    }
    
    override func update(currentTime: CFTimeInterval) {
        _entManager?.player.rotateToMovement()
        
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
    var foo = false
    override func didApplyConstraints() {
        if !foo {
            _entManager?.makeWheel()
            _entManager?.makeWheel()
            _entManager?.makeWheel()
            
            foo = true
        }
        //_wheelPlacer?.update()
        
        if /*!_grid_rendered &&*/ _wheelPlacer != nil {
//            _grid_rendered = true
            
            for wheel in (_wheelPlacer?.wheels)! where wheel.parent != nil {
                _grid!.addCircle(wheel.position, radius: wheel.radius)
            }
            
            _grid!.drawDebugCells(self)
        }
        
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
                    let move = SKAction.moveToY(wheel.position.y, duration: 0.2)
                    
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
        if let player = player, pm = _physicsMgr {
            if let water = _water where player.isInWater(water) {
                if !player.isDying {
                    player.highDamping()
                    player.reduceVelocity()
                }
                
                player.startDying()
            } else {
//                if player.position.x < LEFT_EDGE || player.position.x > RIGHT_EDGE {
//                    player.startDying()
//                } else {
//                  player.stopDying()
//                }
//                
//                player.normalDamping()
//                pm.setNormalGravity()
            }
        }
    }
    
    func shouldRemoveFromScene (node: SKNode) -> Bool {
        if let water = _water {
            return node.position.y < (water.position.y - water.size.height/2)
        }
        
        return false
    }
    
    func shouldHide (node: SKNode) -> Bool {
        let pos = node.position
        
        return node.parent != nil &&
               pos.y < (camera!.position.y - frame.size.height) ||
               pos.y > (camera!.position.y + frame.size.height)
    }
    
// verify that just .position works
    func shouldUnide (node: SKNode) -> Bool {
        let pos = node.position
        
        return node.parent == nil &&
            pos.y > (camera!.position.y - frame.size.height) &&
            pos.y < (camera!.position.y + frame.size.height)
    }
}
