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
    let scene: SKScene
    let frame_size: CGSize
    var wheels = [SKNode]()
    
    let MIN_RADIUS: Int = 25
    let MAX_RADIUS: Int
    let MIN_DISTANCE: CGFloat = 20
    let MAX_DISTANCE: CGFloat = 200
    
    init(scene: SKScene) {
        self.scene = scene
        frame_size = scene.size
        MAX_RADIUS = Int((scene.size.width - WALL_WIDTH * 2) * 0.8 / 2) // 80% of available space
    }
    
    func update() {
        let max_y = scene.camera!.position.y + frame_size.height/2

        while wheels.last?.position.y <= max_y {
            placeWheel()
        }
    }
    
    func placeWheel() -> SKNode {
        var last_wheel: SKNode?
        
        if let _last_wheel = wheels.last {
            last_wheel = _last_wheel
        }
        
        let wheel = SKShapeNode(circleOfRadius: getRandomRadius())
        wheel.lineWidth = 0
        wheel.fillColor = SKColor.blueColor()
        wheel.fillTexture = SKTexture(imageNamed: "wheel-red")
        
        let position = CGPoint(
            x: getRandomX(wheel),
            y: last_wheel != nil ? last_wheel!.position.y : frame_size.height / -2
        )
        
        wheel.position = position
        
        if last_wheel == nil {
            wheels.append(wheel)
            scene.addChild(wheel)
        } else {
            adjustWheelPosition(wheel)
            wheels.append(wheel)
            scene.addChild(wheel)
        }
        
        return wheel
    }
    
    func adjustWheelPosition (wheel: SKNode) {
        var ok = true
        
        wheels.forEach { w in
            if spaceBetweenCircles(wheel, w) < MIN_DISTANCE {
                ok = false
            }
        }
        
        if !ok {
            wheel.position.y += 1
            adjustWheelPosition(wheel)
        } else {
            wheel.position.y = getRandomY(wheel)
        }
    }
    
    func getRandomRadius () -> CGFloat {
        let rand = GKRandomDistribution(lowestValue: MIN_RADIUS, highestValue: MAX_RADIUS)
        
        return CGFloat(rand.nextInt())
    }
    
    func getRandomX(wheel: SKNode) -> CGFloat {
        let min = Int(WALL_WIDTH + wheel.frame.width / 2 + MIN_DISTANCE - frame_size.width / 2)
        let max = Int(frame_size.width / 2 - WALL_WIDTH - MIN_DISTANCE - wheel.frame.width / 2)
        
        let rand = GKRandomDistribution(lowestValue: min, highestValue: max)
        
        return CGFloat(rand.nextInt())
    }

    func getRandomY(wheel: SKNode) -> CGFloat {
        let min = Int(wheel.position.y)
        let max = min + Int(MAX_DISTANCE - MIN_DISTANCE)
        
        let rand = GKRandomDistribution(lowestValue: min, highestValue: max)
        
        return CGFloat(rand.nextInt())
    }

    
    func distanceBetweenPoints(a: CGPoint, _ b: CGPoint) -> CGFloat {
        let val = pow(b.x - a.x, 2) + pow(b.y - a.y, 2)
        return sqrt(val)
    }
    
    /**
    Calculates distance between edges of two circles on a line
    between their centers.
    */
    func spaceBetweenCircles(lhs: SKNode, _ rhs: SKNode) -> CGFloat {
        let dist = distanceBetweenPoints(lhs.position, rhs.position)
        
        return dist - lhs.frame.width/2 - rhs.frame.width/2
    }
}
    