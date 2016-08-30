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
    
    private static var _randomRadius: GKRandomDistribution!
    private var MIN_OBJ_DISTANCE: CGFloat = 30 // calc this based on something
    private var MAX_OBJ_DISTANCE: CGFloat
    
    init(scene: GameScene) {
        self.scene = scene
        MAX_OBJ_DISTANCE = (self.scene.size.width) * 0.5 / 2
        
        EntityManager._randomRadius = GKRandomDistribution(
            lowestValue: 25,
            highestValue: Int(MAX_OBJ_DISTANCE)
        )
    }
    
    func add(entity: GKEntity) {
        if let sprite = entity.componentForClass(SpriteComponent) {
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
    
    func makeWheel() {
        let wheel = WheelEntity(randomRadius: EntityManager._randomRadius)
        placeObject(wheel)
        add(wheel)
    }
    
    func placeObject(entity: GKEntity) {
        if var position = entity.componentForClass(SpriteComponent)?.node.position {
            position.x = getRandomX(entity)
            position.y = getInitialY()
        }
    }
    
    func getInitialY() -> CGFloat {
        let y: CGFloat
        
        if let last_position = getHighestSprite(WheelEntity)?.componentForClass(SpriteComponent)?.node.position {
            y = last_position.y + 1
        } else {
            y = scene.frame.size.height / -2
        }
        
        return y
    }
    
    func getRandomX(entity: GKEntity) -> CGFloat {
        let wheel = entity.componentForClass(SpriteComponent)!.node
        let min = Int(wheel.frame.width / 2 + MIN_OBJ_DISTANCE - scene.frame.size.width / 2)
        let max = Int(scene.frame.size.width / 2 - MIN_OBJ_DISTANCE - wheel.frame.width / 2)
        
        let rand = GKRandomDistribution(lowestValue: min, highestValue: max)
        
        return CGFloat(rand.nextInt())
    }
    
    func getRandomY(entity: GKEntity) -> CGFloat {
        let y: CGFloat
        
        if let last_position = getHighestSprite(WheelEntity)?.componentForClass(SpriteComponent)?.node.position {
            y = last_position.y
        } else {
            y = scene.frame.size.height / -2
        }
        
        return y
    }
    
    func distanceBetweenObjects(lhs: GKEntity, _ rhs: GKEntity) -> CGFloat {
        let o1 = lhs.componentForClass(SpriteComponent)!
        let o2 = rhs.componentForClass(SpriteComponent)!
        
        let dist = distanceBetweenPoints(o1.node.position, o2.node.position)
        
        return dist - o1.node.frame.width/2 - o2.node.frame.width/2
    }
    
    func getObjectWithin(radius: CGFloat) -> [GKEntity] {
        return entities.filter { el in
            return true
        }
    }
    
    func getHighestSprite(ofType: AnyClass) -> GKEntity? {
        var objects = entities.filter {el in
            return el.isKindOfClass(ofType) &&
                   el.componentForClass(SpriteComponent) != nil
        }
        
        if objects.count == 0 {
            return nil
        }
        
        objects.sortInPlace { (a, b) -> Bool in
            let n1 = a.componentForClass(SpriteComponent)!.node
            let n2 = b.componentForClass(SpriteComponent)!.node
            
            return n1.position.y > n2.position.y
        }
        
        return objects[0]
    }
}