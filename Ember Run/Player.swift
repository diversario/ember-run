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
    private unowned let _physicsManager: PhysicsEntity
    
    private var _fieldNode: SKFieldNode?

    private var _health = 1
    private var _isDying = false
    
    private var _isOnWheel: SKSpriteNode? = nil
    
    private var _positioned: Bool {
        return parent != nil
    }
    
    var radius: CGFloat {
        return self.size.height / 2
    }
    
    var isOnWheel: SKSpriteNode? {
        get {
            return _isOnWheel
        }
        
        set {
            _isOnWheel = newValue
        }
    }
    
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
    
    init (scene: GameScene, physicsManager: PhysicsEntity) {
        _scene = scene
        _physicsManager = physicsManager
        
        super.init(texture: Player.Texture, color: SKColor.clear, size: Player.Texture.size())
        
        _setAttributes()
        
        Player._instance = self
    }
    
    deinit {
        print("DEINIT PLAYER")
    }
    
    required init?(coder aDecoder: NSCoder) {
        _scene = GameScene(fileNamed: "GameScene")!
        _physicsManager = PhysicsEntity(scene: _scene)
        
        super.init(coder: aDecoder)
    }

    private func _setAttributes () {
        zPosition = Z.PLAYER
    }
    
    func positionPlayer(_ pos: CGPoint) {
        if !_positioned {
            position = pos
            
            _initPlayerNode()
            
            _scene.addChild(self)
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
    
//    func syncParticles() {
//        _particleTrail.position = position
//    }
    
    
    private func _initPlayerNode() {
        _setPhysicsBody()
        
        name = "player"
        
        //_particleTrail.targetNode = _node
        //_node.addChild(_particleTrail)
        // _scene.addChild(_particleTrail)
    }
    
    private func _setPhysicsBody() {
        physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        physicsBody!.contactTestBitMask = CONTACT_MASK.PLAYER
        physicsBody!.collisionBitMask = COLLISION_MASK.PLAYER
        physicsBody!.categoryBitMask = CAT.PLAYER
        
        physicsBody!.usesPreciseCollisionDetection = false
        
        physicsBody!.mass = 0.01 * SCREEN_SCALE
        
        physicsBody!.fieldBitMask = CAT.PLAYER
        _fieldNode = SKFieldNode.springField()
        _fieldNode!.strength = 100
        _fieldNode!.categoryBitMask = CAT.COIN
        _fieldNode!.region = SKRegion(radius: Float(radius * 6))
        
        addChild(_fieldNode!)
        
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
    
    func isInWater (_ water: Water) -> Bool {
        return position.y < water.waterline
    }
    
    func rotateToMovement () {
        if let vel = physicsBody?.velocity {
            let point_y = position.y - vel.dy
            let point_x = position.x - vel.dx
            
            let angle = atan2(point_y - position.y , point_x - position.x) + CGFloat((M_PI/180) * 90.0)
            
            zRotation = angle
        }
    }
    
    private func getJumpVector () -> CGVector? {
        let playerCoords = position
        
        var vector: CGVector?
        
        if _physicsManager.isPlayerOnWheel {
            if let wheel = _physicsManager.wheel {
                vector = CGVector(dx: playerCoords.x - wheel.position.x, dy: playerCoords.y - wheel.position.y)
                vector = normalizeVector(vector!)
                
                vector!.dx *= IMPULSE.WHEEL
                vector!.dy *= IMPULSE.WHEEL
            }
        }

        return vector
    }
    
    func orientToMovement (_ impulse: CGVector) {
        let angle = getPlayerRotationAngle(impulse)
        
        let rotate = SKAction.rotate(toAngle: angle, duration: 0.03, shortestUnitArc: true)
        run(rotate)
    }
    
    func startDying () {
        if !self._isDying {
            print("💀💀💀💀💀💀💀💀")
            self._isDying = true
            run(_getDecreaseHealthAction())
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
        let wait = SKAction.wait(forDuration: 0)
        
        let decreaseHealth = SKAction.run { _ in
            self._startDecreasingHealth()
        }
        
        return SKAction.sequence([wait, decreaseHealth])
    }
    
    private func _startDecreasingHealth() {
        let delta: Int64 = 10 * Int64(NSEC_PER_SEC / 1000) // ns -> ms
        let time = DispatchTime.now() + Double(delta) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            self._health -= 1
            
            if self._isDying && self._health > 0 {
                self._startDecreasingHealth()
            }
        });
    }
}

private let _angleAdjustment = CGFloat(90 * M_PI/180.0)

func getPlayerRotationAngle(_ v: CGVector) -> CGFloat {
    return atan2(v.dy, v.dx) - _angleAdjustment
}
