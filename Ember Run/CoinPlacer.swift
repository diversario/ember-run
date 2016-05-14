//
//  CoinPlacer.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 5/11/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit

class CoinPlacer {
    private unowned var _scene: GameScene
    
    private let _coins = [Coin]()
    private let _pins = [CoinPin]()
    
    private var _wheelIdx = 0
    
    init(scene: GameScene) {
        _scene = scene
    }
    
    private func _placeCoin() {
        let coin = Coin(scene: _scene)
        let pin = CoinPin(scene: _scene)
    }
    
    private func _getPosition() -> CGPoint? {
        if let wp = WheelPlacer.instance where wp.wheels.count > _wheelIdx {
            
        }
        
        return nil
    }
}