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
    private unowned let _scene: GameScene
    private let _frame_size: CGSize
    private var _wheels = [Wheel]()
//    private var _wheels_dict = [ Double: Wheel ]()
    
    private let _MIN_DISTANCE: CGFloat = 20
    private let _MAX_DISTANCE: CGFloat// = 200

    init(scene: GameScene) {
        self._scene = scene
        _frame_size = scene.size
        Wheel.MAX_RADIUS = Int((scene.size.width - WALL_WIDTH * 2) * 0.8 / 2) // 80% of available space
        _MAX_DISTANCE = CGFloat(Wheel.MAX_RADIUS) * 1.05
    }
    
    deinit {
        print("DEINIT WHEELPLACER")
    }
    
    func update() {
        let max_y = _scene.camera!.position.y + _frame_size.height/2

        while _wheels.last?.position.y <= max_y {
            _placeWheel()
        }

        for wheel in _wheels {
            if _scene.shouldRemoveFromScene(wheel) {
//                print("REMOVE \(wheel.name)")
                wheel.removeFromParent()
                wheel.removeAllActions()
                _wheels.removeAtIndex(_wheels.indexOf(wheel)!)
            } else if wheel.parent != nil && _scene.shouldHide(wheel) {
//                print("HIDE \(wheel.name)")
                wheel.removeFromParent()
            } else if wheel.parent == nil && _scene.shouldUnide(wheel) {
//                print("UNHIDE \(wheel.name)")
                _scene.effect.addChild(wheel)
            }
        }
    }
    
    private func _placeWheel() -> SKNode {
        var last_wheel: SKNode?
        
        if let _last_wheel = _wheels.last {
            last_wheel = _last_wheel
        }
        
        let wheel = Wheel()
        
        let position = CGPoint(
            x: _getRandomX(wheel),
            y: last_wheel != nil ? last_wheel!.position.y + 1.0 : _frame_size.height / -2 // y + 1 to avoid hash collisions
        )
        
        wheel.position = position
        wheel.positionInScene = position
        
        if last_wheel == nil {
            _wheels.append(wheel)
            _scene.effect.addChild(wheel)
        } else {
            _adjustWheelPosition(wheel)
            _wheels.append(wheel)
            _scene.effect.addChild(wheel)
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
    
    /**
    Calculates distance between edges of two circles on a line
    between their centers.
    */
    private func _spaceBetweenCircles(lhs: SKNode, _ rhs: SKNode) -> CGFloat {
        let dist = distanceBetweenPoints(lhs.position, rhs.position)
        
        return dist - lhs.frame.width/2 - rhs.frame.width/2
    }
}
    