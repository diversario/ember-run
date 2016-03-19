//
//  Player.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 3/5/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    private static var _instance: Player!
    
    private static let Texture = SKTexture(imageNamed: "player")

    private unowned let _scene: GameScene
    private unowned let _physicsManager: PhysicsManager
    
    private var _positioned = false
    private var _health = 100
    private var _isDying = false
    
    private var _particleTrail = SKEmitterNode(fileNamed: "PlayerTrail")!
    
    var velocity: CGVector? {
        get {
            return physicsBody?.velocity
        }
        set {
            physicsBody?.velocity = newValue!
        }
    }
    
    var health: Int {
        return _health
    }
    
    var isDying: Bool {
        return _isDying
    }
    
    static func getPlayer () -> Player? {
        if let p = Player._instance {
            return p
        }
        
        return nil
    }
    
    init (scene: GameScene, physicsManager: PhysicsManager) {
        _scene = scene
        _physicsManager = physicsManager
        
        super.init(texture: Player.Texture, color: SKColor.clearColor(), size: Player.Texture.size())
        
        _setAttributes()
        
        Player._instance = self
    }
    
    deinit {
        print("DEINIT PLAYER")
    }
    
    required init?(coder aDecoder: NSCoder) {
        _scene = GameScene(fileNamed: "GameScene")!
        _physicsManager = PhysicsManager(scene: _scene)
        
        super.init(coder: aDecoder)
    }

    private func _setAttributes () {
        zPosition = Z.PLAYER
    }
    
    func positionPlayer(pos: CGPoint) {
        if !_positioned {
            position = pos
            
            _initPlayerNode()
            
            _scene.addChild(self)
            _positioned = true
        }
    }
    
    func onTap () {
        if let impulse = getJumpVector() {
            if _physicsManager.isPlayerOnWheel {
                _physicsManager.detachPlayerFromWheel()
            } else {
                _setPhysicsBody()
            }
            
            orientToMovement(impulse)
            
            physicsBody?.applyImpulse(impulse)
        }
    }
    
    func syncParticles() {
        _particleTrail.position = position
    }
    
    
    private func _initPlayerNode() {
        _setPhysicsBody()
        
        name = "player"
        
        let constr = SKConstraint.positionX(
            SKRange(
                lowerLimit: _scene.LEFT_EDGE + size.width / 2,
                upperLimit: _scene.RIGHT_EDGE - size.width / 2
            )
        )
        
        constraints = [constr]
        
        //_particleTrail.targetNode = _node
        //_node.addChild(_particleTrail)
        _scene.addChild(_particleTrail)
    }
    
    private func _setPhysicsBody() {
        physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        physicsBody!.contactTestBitMask = CONTACT_MASK.PLAYER
        physicsBody!.collisionBitMask = COLLISION_MASK.PLAYER
        physicsBody!.categoryBitMask = CAT.PLAYER
        
        physicsBody!.usesPreciseCollisionDetection = true
        
        physicsBody!.mass = 0.01 * SCREEN_SCALE
        
        normalDamping()
    }
    
    func highDamping () {
        physicsBody?.linearDamping = 1
        physicsBody?.angularDamping = 1
    }
    
    func normalDamping () {
        physicsBody?.linearDamping = 0.2
        physicsBody?.angularDamping = 0.2
    }
    
    func reduceVelocity () {
        physicsBody?.velocity = CGVector(
            dx: physicsBody!.velocity.dx / 3,
            dy: physicsBody!.velocity.dy / 3
        )
        
    }
    
    func isInWater (water: Water) -> Bool {
        return position.y < water.waterline
    }
    
    private func getJumpVector () -> CGVector? {
        let playerCoords = position
        
        var vector: CGVector?
        
        if _physicsManager.isPlayerOnWheel {
            if let wheel = _physicsManager.wheel {
                vector = CGVectorMake(playerCoords.x - wheel.position.x, playerCoords.y - wheel.position.y)
                vector = normalizeVector(vector!)
                
                vector!.dx *= IMPULSE.WHEEL
                vector!.dy *= IMPULSE.WHEEL
            }
        } else if _isOnTheWall() {
            if playerCoords.x < 0 { // it's on the left wall
                vector = CGVectorMake(1, 1)
            } else {
                vector = CGVectorMake(-1, 1)
            }
            
            vector = normalizeVector(vector!)
            
            vector!.dx *= IMPULSE.WALL
            vector!.dy *= IMPULSE.WALL
        }

        return vector
    }
    
    private func _isOnTheWall () -> Bool {
        let left_threshold = ceil(_scene.LEFT_EDGE + size.width / 2)
        let right_threshold = floor(_scene.RIGHT_EDGE - size.width / 2)
        
        return ceil(position.x) <= left_threshold ||
            floor(position.x) >= right_threshold
    }
    
    private func _isOnWheel () -> Bool {
        if let name = parent?.name {
            return name.containsString("wheel")
        }
        
        return false
    }
    
    func orientToMovement (impulse: CGVector) {
        let angle = getPlayerRotationAngle(impulse)
        
        let rotate = SKAction.rotateToAngle(angle, duration: 0.03, shortestUnitArc: true)
        runAction(rotate)
    }
    
    func startDying () {
        if !self._isDying {
            print("💀💀💀💀💀💀💀💀")
            self._isDying = true
            //_node.runAction(_getDecreaseHealthAction())
        }
    }
    
    func stopDying () {
        if isDying {
            removeAllActions()
            _isDying = false
            print("😅😅😅😅😅😅😅😅😅😅")
        }
    }
    
    private func _getDecreaseHealthAction () -> SKAction {
        let wait = SKAction.waitForDuration(0.7)
        
        let decreaseHealth = SKAction.runBlock { _ in
            self._startDecreasingHealth()
        }
        
        return SKAction.sequence([wait, decreaseHealth])
    }
    
    private func _startDecreasingHealth() {
        let delta: Int64 = 10 * Int64(NSEC_PER_SEC / 1000)
        let time = dispatch_time(DISPATCH_TIME_NOW, delta)
        
        dispatch_after(time, dispatch_get_main_queue(), {
            self._health--
            
            if self._isDying && self._health > 0 {
                self._startDecreasingHealth()
            }
        });
    }
}

private let _angleAdjustment = CGFloat(90 * M_PI/180.0)

func getPlayerRotationAngle(v: CGVector) -> CGFloat {
    return atan2(v.dy, v.dx) - _angleAdjustment
}