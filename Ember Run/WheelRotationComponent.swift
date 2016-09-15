//
//  WheelRotationComponent.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 8/21/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class WheelRotationComponent: GKComponent {
    init (sprite: SKSpriteNode) {
        super.init()
        sprite.runAction(_setRotation())
    }
    
    private var _rotationDirection: ROTATION_DIRECTION!
    
    var direction: ROTATION_DIRECTION {
        return _rotationDirection
    }
    
    private static let _randomAngularSpeed = GKRandomDistribution(lowestValue: 20, highestValue: 40)
    
    private func _setRotation () -> SKAction {
        let rotate = _getRandomRotationAction()
        return SKAction.repeatActionForever(rotate)
    }
    
    private func _getRandomRotationAction() -> SKAction {
        let direction: CGFloat = randomBool.nextBool() ? 1 : -1
        
        _rotationDirection = direction > 0 ? .CCW : .CW
        
        let angle = _getRandomAngularSpeed() * direction
        return SKAction.rotateByAngle(angle, duration: 1)
    }
    
    private func _getRandomAngularSpeed() -> CGFloat {
        return CGFloat(CGFloat(WheelRotationComponent._randomAngularSpeed.nextInt()) / 10.0)
    }
    
    deinit {
        print("DEINIT WheelRotationComponent")
    }
}