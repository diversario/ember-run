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

func normalizeVector (v: CGVector) -> CGVector {
    let length = sqrt(pow(v.dx, 2) + pow(v.dy, 2))
    
    return CGVector(dx: v.dx/length, dy: v.dy/length)
}

func distanceBetweenPoints(a: CGPoint, _ b: CGPoint) -> CGFloat {
    let val = pow(b.x - a.x, 2) + pow(b.y - a.y, 2)
    return sqrt(val)
}
