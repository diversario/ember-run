//
//  Util.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 2/17/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit

func normalizeVector (v: CGVector) -> CGVector {
    let length = sqrt(pow(v.dx, 2) + pow(v.dy, 2))
    
    return CGVector(dx: v.dx/length, dy: v.dy/length)
}