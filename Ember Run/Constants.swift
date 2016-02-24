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

struct BODY {
    static let WHEEL: UInt32 = 0x1 << 0
    static let PLAYER: UInt32 = 0x1 << 1
    static let WATER: UInt32 = 0x1 << 2
}

struct CAT {
    static let WHEEL: UInt32 = 0x1 << 0
    static let PLAYER: UInt32 = 0x1 << 1
    static let WATER: UInt32 = 0x1 << 2
}

let SCREEN_SCALE = CGFloat(UIScreen.mainScreen().scale == 2 ? 2 : 4)