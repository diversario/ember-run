//
//  Constants.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 2/13/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import UIKit

let WALL_WIDTH = UIImage(named: "wall tile")!.size.width

struct Z {
    static let WALL: CGFloat = 500
    static let WHEEL: CGFloat = 100
    static let PLAYER: CGFloat = 300
    static let WATER: CGFloat = 400
}

struct CAT {
    static let WHEEL: UInt32 = 0x1 << 0
    static let PLAYER: UInt32 = 0x1 << 1
    static let WATER: UInt32 = 0x1 << 2
}

struct COLLISION_MASK {
    static let WHEEL: UInt32 = 0
    static let PLAYER: UInt32 = 0
    static let WATER: UInt32 = 0
}

struct CONTACT_MASK {
    static let WHEEL: UInt32 = 0
    static let PLAYER: UInt32 = CAT.WHEEL | CAT.WATER
    static let WATER: UInt32 = 0
}

let SCREEN_SCALE = UIScreen.mainScreen().scale

private let FAKE_PX_TO_M_RATIO: CGFloat = 80

struct IMPULSE {
    static let WALL = sqrt(UIScreen.mainScreen().bounds.width * SCREEN_SCALE * SCREEN_SCALE / FAKE_PX_TO_M_RATIO) * sqrt(SCREEN_SCALE) * 1.45
    static let WHEEL = sqrt(UIScreen.mainScreen().bounds.width * SCREEN_SCALE * SCREEN_SCALE / FAKE_PX_TO_M_RATIO) * sqrt(SCREEN_SCALE) * 1.35
}
