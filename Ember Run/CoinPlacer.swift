//
//  CoinPlacer.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 5/11/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class CoinPlacer {
    private unowned var _scene: GameScene
    private let _frame_size: CGSize
    
    private var _coins = [Coin]()
    private let _pins = [CoinPin]()
    
    private var _wheelIdx = 0
    
    init(scene: GameScene) {
        _scene = scene
        _frame_size = _scene.size
    }
    
    func placeCoins() {
        while _coins.count <= 1 {
            _placeCoin()
        }
    }
    
    private func _placeCoin() {
        let coin = Coin(scene: _scene)
        let pin = CoinPin(scene: _scene)
        
        coin.position = CGPoint(x: _getRandomX(coin), y: _getRandomY(coin))
        _coins.append(coin)
        
        _getPosition(coin)
        _scene.addChild(coin)
    }
    
    private func _getPosition(_ coin: Coin) -> CGPoint? {
//        if let wp = WheelPlacer.instance , wp.wheels.count > _wheelIdx {
//            for wheel in wp.wheels where wheel.parent != nil {
//                let dist = getDistance(coin.position, p2: wheel.position)
//                
//                if dist < wheel.radius {
//                    coin.position = CGPoint(x: _getRandomX(coin), y: _getRandomY(coin))
//                    _getPosition(coin)
//                    break
//                }
//            }
//        }
        
        return nil
    }
    
    private func getDistance(_ p1: CGPoint, p2: CGPoint) -> CGFloat {
        return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2))
    }
    
    private func _getRandomX(_ coin: Coin) -> CGFloat {
        let min = Int(coin.frame.width / 2 - 10 + _frame_size.width / 2)
        let max = Int(_frame_size.width / 2 - 10 - coin.frame.width / 2)
        
        let rand = GKRandomDistribution(lowestValue: min, highestValue: max)
        
        return CGFloat(rand.nextInt())
    }
    
    private func _getRandomY(_ coin: Coin) -> CGFloat {
        let min = Int(coin.position.y)
        let max = min + Int(200 - 20)
        
        let rand = GKRandomDistribution(lowestValue: min, highestValue: max)
        
        return CGFloat(rand.nextInt())
    }
}
