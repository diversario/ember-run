//
//  EntityManager.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 8/20/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class EntityManager {
    let scene: GameScene
    var entities = Set<GKEntity>()
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func add(entity: GKEntity) {
        if let sprite = entity.componentForClass(SpriteComponent.self) {
            scene.addChild(sprite.node)
        }
        
        entities.insert(entity)
    }
    
    func remove(entity: GKEntity) {
        entities.remove(entity)
    }
    
    func setVisibility(node: SKSpriteNode) {
        if scene.shouldHide(node) {
            node.removeFromParent()
            node.paused = true
        } else if scene.shouldUnide(node) {
            scene.addChild(node)
            node.paused = false
        }
    }
    
    func setExistence(entity: GKEntity) {
        if let sprite = entity.componentForClass(SpriteComponent) {
            if scene.shouldRemoveFromScene(sprite.node) {
                sprite.node.removeFromParent()
                remove(entity)
            }
        }
    }
    
    func placeWheel(wheel: WheelEntity) {
        
    }
}