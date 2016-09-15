//
//  PlayerHealthComponent.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 9/12/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import GameplayKit

class PlayerHealthComponent: GKComponent {
    fileprivate var _health: Double = 100
    
    var health: Double {
        return _health
    }
    
    func update(_ seconds: TimeInterval, shouldDecrease: Bool) {
        if shouldDecrease {
            _health -= seconds * 100
        }
    }
    
    deinit {
        print("DEINIT PlayerHealthComponent")
    }
}
