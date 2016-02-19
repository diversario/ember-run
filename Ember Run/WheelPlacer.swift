//
//  WheelPlacer.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 2/13/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class WheelPlacer {
    private let _scene: SKScene
    private let _frame_size: CGSize
    private var _wheels = [SKNode]()
    
    private let _randomRadius: GKRandomDistribution!
    private let _randomAngularSpeed = GKRandomDistribution(lowestValue: 20, highestValue: 40)
    
    private let _MIN_RADIUS: Int = 25
    private let _MAX_RADIUS: Int
    private let _MIN_DISTANCE: CGFloat = 20
    private let _MAX_DISTANCE: CGFloat = 200

    init(scene: SKScene) {
        self._scene = scene
        _frame_size = scene.size
        _MAX_RADIUS = Int((scene.size.width - WALL_WIDTH * 2) * 0.8 / 2) // 80% of available space
        
        _randomRadius = GKRandomDistribution(lowestValue: _MIN_RADIUS, highestValue: _MAX_RADIUS)
    }
    
    func update() {
        let max_y = _scene.camera!.position.y + _frame_size.height/2

        while _wheels.last?.position.y <= max_y {
            _placeWheel()
        }
    }
    
    private func _makeWheel () -> SKNode {
        let radius = _getRandomRadius()
        let wheel = SKSpriteNode(imageNamed: "wheel")

        wheel.size = CGSize(width: radius * 2, height: radius * 2)
        
        wheel.physicsBody = SKPhysicsBody(circleOfRadius: radius - 1)
        wheel.physicsBody!.affectedByGravity = false
        wheel.physicsBody!.dynamic = false
        wheel.physicsBody!.contactTestBitMask = PhysicsManager.bodies.player | PhysicsManager.bodies.wheel
        wheel.physicsBody!.usesPreciseCollisionDetection = true
        wheel.physicsBody!.restitution = 0
        
        wheel.name = "wheel\(_wheels.count)"
        
        let rotate = _getRandomRotationAction()
        wheel.runAction(SKAction.repeatActionForever(rotate))
        
        return wheel
    }
    
    private func _placeWheel() -> SKNode {
        var last_wheel: SKNode?
        
        if let _last_wheel = _wheels.last {
            last_wheel = _last_wheel
        }
        
        let wheel = _makeWheel()
        
        let position = CGPoint(
            x: _getRandomX(wheel),
            y: last_wheel != nil ? last_wheel!.position.y : _frame_size.height / -2
        )
        
        wheel.position = position
        
        if last_wheel == nil {
            _wheels.append(wheel)
            _scene.addChild(wheel)
        } else {
            _adjustWheelPosition(wheel)
            _wheels.append(wheel)
            _scene.addChild(wheel)
        }
        
        return wheel
    }
    
    private func _adjustWheelPosition (wheel: SKNode) {
        var ok = true
        
        for w in _wheels {
            if _spaceBetweenCircles(wheel, w) < _MIN_DISTANCE {
                ok = false
                break
            }
        }
        
        if !ok {
            wheel.position.y += 1
            _adjustWheelPosition(wheel)
        } else {
            wheel.position.y = _getRandomY(wheel)
        }
    }
    
    private func _getRandomX(wheel: SKNode) -> CGFloat {
        let min = Int(WALL_WIDTH + wheel.frame.width / 2 + _MIN_DISTANCE - _frame_size.width / 2)
        let max = Int(_frame_size.width / 2 - WALL_WIDTH - _MIN_DISTANCE - wheel.frame.width / 2)
        
        let rand = GKRandomDistribution(lowestValue: min, highestValue: max)
        
        return CGFloat(rand.nextInt())
    }

    // refactor to calculate space between edges, not centers
    private func _getRandomY(wheel: SKNode) -> CGFloat {
        let min = Int(wheel.position.y)
        let max = min + Int(_MAX_DISTANCE - _MIN_DISTANCE)
        
        let rand = GKRandomDistribution(lowestValue: min, highestValue: max)
        
        return CGFloat(rand.nextInt())
    }

    
    private func _getRandomRadius () -> CGFloat {
        return CGFloat(_randomRadius.nextInt())
    }

    private func _getRandomAngularSpeed() -> CGFloat {
        return CGFloat(CGFloat(_randomAngularSpeed.nextInt()) / 10.0)
    }
    
    private func _getRandomRotationAction() -> SKAction {
        let angle = _getRandomAngularSpeed() * (randomBool.nextBool() ? 1 : -1)
        return SKAction.rotateByAngle(angle, duration: 1)
    }

    
    /**
    Calculates distance between edges of two circles on a line
    between their centers.
    */
    private func _spaceBetweenCircles(lhs: SKNode, _ rhs: SKNode) -> CGFloat {
        let dist = distanceBetweenPoints(lhs.position, rhs.position)
        
        return dist - lhs.frame.width/2 - rhs.frame.width/2
    }
}
    