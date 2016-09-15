//
//  Wheel.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 3/5/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

// clockwise, counterclockwise
enum ROTATION_DIRECTION {
    case CW
    case CCW
}

class Wheel: SKSpriteNode {
    static var MIN_RADIUS: Int! = 25
    static var MAX_RADIUS: Int!
    
    private static let _randomAngularSpeed = GKRandomDistribution(lowestValue: 20, highestValue: 40)
    private static var WHEEL_COUNT = 0
    
    private static var _randomRadius: GKRandomDistribution!
    private var _radius: CGFloat!
    private var _parentNode: GameScene?
    
    private var _rotationDirection: ROTATION_DIRECTION?
    
    var direction: ROTATION_DIRECTION {
        return _rotationDirection!
    }
    
    var velocity: CGFloat {
        return physicsBody!.angularVelocity
    }
    
    var radius: CGFloat {
        return _radius
    }
    
    init () {
        Wheel.WHEEL_COUNT += 1
        
        if Wheel._randomRadius == nil {
            Wheel._randomRadius = GKRandomDistribution(
                lowestValue: Wheel.MIN_RADIUS,
                highestValue: Wheel.MAX_RADIUS
            )
        }
        
        // actual init
        let color = UIColor.clearColor()
        
        _radius = CGFloat(Wheel._randomRadius.nextInt())
        
        let texture = _getTexture(_radius)

        let size = CGSize(width: _radius * 2, height: _radius * 2)
        
        super.init(texture: texture, color: color, size: size)
        
        _setAttributes()
        _setPhysicsBody()
        _setRotation()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func prepareToDie () {
        removeFromParent()
        removeAllActions()
    }
    
    func update() {
        var scene: GameScene?

        if let _p = parent as? GameScene {
            scene = _p
        } else if let _p = _parentNode {
            scene = _p
        }
//
//        if let scene = scene {
//            if scene.shouldHide(self) && self.parent != nil {
//                _parentNode = scene
//                self.removeFromParent()
//                self.paused = true
//            } else if scene.shouldUnide(self) && self.parent == nil {
//                scene.addChild(self)
//                self.paused = false
//            }
//        }
    }

    func contains (point: CGPoint) -> Bool {
        return distanceBetweenPoints(point, position) <= _radius
    }
    
    private func _setAttributes () {
        zPosition = Z.WHEEL
        name = "wheel\(Wheel.WHEEL_COUNT)"
    }
    
    private func _setPhysicsBody () {
        physicsBody = SKPhysicsBody(circleOfRadius: _radius - 1)
        physicsBody!.affectedByGravity = false
        physicsBody!.dynamic = false
        physicsBody!.contactTestBitMask = CONTACT_MASK.WHEEL
        physicsBody!.collisionBitMask = COLLISION_MASK.WHEEL
        physicsBody!.categoryBitMask = CAT.WHEEL
        physicsBody!.usesPreciseCollisionDetection = false
    }
    
    private func _setRotation () {
        let rotate = _getRandomRotationAction()
        runAction(SKAction.repeatActionForever(rotate))
    }
    
    private func _getRandomRotationAction() -> SKAction {
        let direction: CGFloat = randomBool.nextBool() ? 1 : -1
        
        _rotationDirection = direction > 0 ? .CCW : .CW
        
        let angle = _getRandomAngularSpeed() * direction
        return SKAction.rotateByAngle(angle, duration: 1)
    }
    
    private func _getRandomAngularSpeed() -> CGFloat {
        return CGFloat(CGFloat(Wheel._randomAngularSpeed.nextInt()) / 10.0)
    }
}

private func _getTexture (radius: CGFloat) -> SKTexture {
    let step = CGFloat((Wheel.MAX_RADIUS - Wheel.MIN_RADIUS)) / 4.0 // 5 wheels. Should be programmatic tho
    let num = radius - CGFloat(Wheel.MIN_RADIUS)
    let texture_num = round(num / step) + 1
    
    return SKTexture(imageNamed: "wheel-\(texture_num)")
}