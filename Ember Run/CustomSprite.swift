//
//  CustomSprite.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 4/25/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit

protocol CustomSprite {
    var positionInScene: CGPoint! {get set}
    var parent: SKNode? { get }
    var name: String? { get set }
}
