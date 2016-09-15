//
//  Util.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 2/17/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

let randomBool = GKRandomDistribution()

func normalizeVector (_ v: CGVector) -> CGVector {
    let length = vectorLength(v)
    
    return CGVector(dx: v.dx/length, dy: v.dy/length)
}

func distanceBetweenPoints(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
    let val = pow(b.x - a.x, 2) + pow(b.y - a.y, 2)
    return sqrt(val)
}

func vectorLength (_ v: CGVector) -> CGFloat {
    return sqrt(pow(v.dx, 2) + pow(v.dy, 2))
}
