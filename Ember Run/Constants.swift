//
//  Constants.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 2/13/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import UIKit

struct Z {
    static let WATER: CGFloat = 400
    static let COIN: CGFloat = 350
    static let PLAYER: CGFloat = 300
    static let WHEEL: CGFloat = 100
    static let CLOUD: CGFloat = 60
    static let BACKGROUND: CGFloat = 50
}

struct CAT {
    static let WHEEL: UInt32 = 0x1 << 0
    static let PLAYER: UInt32 = 0x1 << 1
    static let WATER: UInt32 = 0x1 << 2
    static let COIN: UInt32 = 0x1 << 3
}

struct COLLISION_MASK {
    static let WHEEL: UInt32 = 0
    static let PLAYER: UInt32 = 0
    static let WATER: UInt32 = 0
    static let COIN: UInt32 = CAT.WHEEL
}

struct CONTACT_MASK {
    static let WHEEL: UInt32 = 0
    static let PLAYER: UInt32 = CAT.WHEEL
    static let WATER: UInt32 = 0
    static let COIN: UInt32 = CAT.PLAYER
}

let SCREEN_SCALE = UIScreen.mainScreen().scale

private let FAKE_PX_TO_M_RATIO: CGFloat = 80

// http://formulas.tutorvista.com/physics/projectile-motion-formula.html
struct IMPULSE {
    static let WALL = sqrt(UIScreen.mainScreen().bounds.width * SCREEN_SCALE * SCREEN_SCALE / FAKE_PX_TO_M_RATIO) * sqrt(SCREEN_SCALE) * 1.45
    static let WHEEL = sqrt(UIScreen.mainScreen().bounds.width * SCREEN_SCALE * SCREEN_SCALE / FAKE_PX_TO_M_RATIO) * sqrt(SCREEN_SCALE) * 1.35
}
