//
//  WheelPlacer.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 2/13/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit

class WheelPlacer {
    let scene: SKScene
    let frame_size: CGSize
    var wheels = [SKNode]()
    
    let MIN_RADIUS: CGFloat = 25
    let MAX_RADIUS: CGFloat
    let MIN_DISTANCE: CGFloat = 20
    let MAX_DISTANCE: CGFloat = 200
    
    init(scene: SKScene) {
        self.scene = scene
        frame_size = scene.size
        MAX_RADIUS = (scene.size.width - UIImage(named: "wall tile")!.size.width * 2) * 0.8 / 2 // 80% of available space
        
    }
    
    func update() {
        let s1 = SKShapeNode(circleOfRadius: 50)
        s1.position = CGPoint(x: CGRectGetMidX(scene.camera!.frame), y: CGRectGetMidY(scene.camera!.frame))
        s1.fillColor = SKColor.clearColor()
        s1.strokeColor = SKColor.greenColor()
        
        scene.addChild(s1)
        
        let s2 = SKShapeNode(circleOfRadius: 20)
        s2.position = CGPoint(x: CGRectGetMidX(scene.camera!.frame), y: CGRectGetMidY(scene.camera!.frame) + 80)
        s2.fillColor = SKColor.redColor()
        scene.addChild(s2)
        
        wheels.append(s1)
        wheels.append(s2)
    }
    
    func placeWheels() {
        let last_wheel: SKNode?
        
        if let _last_wheel = wheels.last {
            last_wheel = _last_wheel
        }
        
        
    }
    
    func getRandomRadius () -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(MAX_RADIUS - MIN_RADIUS)) + 25)
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
    
//    // also not used
//    func angleBetweenPoints(a: CGPoint, _ b: CGPoint) -> CGFloat {
//        let dx = b.x - a.x
//        let dy = b.y - a.y
//        
//        return atan2(dy, dx)
//    }
//    
//    // written because I'm an idiot. Unused
//    func pointOnCircle(angle : CGFloat, circle: SKNode) -> CGPoint {
//        let ox = circle.position.x + circle.frame.width / 2
//        let oy = circle.position.y
//        
//        let point = CGPoint(
//            x: ox * cos(angle) + oy * sin(angle),
//            y: ox * sin(angle) + oy * cos(angle)
//        )
//        
//        return point
//    }
}
    