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

class EntityManager: PlayerDelegate {
    let scene: GameScene
    let physics: PhysicsEntity
    var entities = Set<GKEntity>()
    
    private var _lastUpdateTime: NSTimeInterval = 0
    
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
        
        physics = PhysicsEntity(scene: scene)
    }
    
    func createEntities() {
        makePlayer()
        makeHazard()
    }
    
    deinit {
        print("DEINIT EntityManager")
    }
    
    var player: PlayerEntity {
        return entities.filter { ent in
            return ent.isMemberOfClass(PlayerEntity)
        } [0] as! PlayerEntity
    }
    
    var hazard: HazardEntity {
        return entities.filter { ent in
            return ent.isMemberOfClass(HazardEntity)
            } [0] as! HazardEntity
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
    
    func update (currentTime: CFTimeInterval) {
        let deltaTime = currentTime - _lastUpdateTime
        _lastUpdateTime = currentTime
        
        player.updateWithDeltaTime(deltaTime, hazardEdge: hazard.edge)
        addWheels()
    }
    
    func addWheels () {
        let max_y = scene.camera!.position.y + scene.frame.size.height/2
        
        let highest_wheel = getHighestSprite(WheelEntity) as? WheelEntity
        
        if highest_wheel == nil {
            makeWheel()
        } else {
            while (getHighestSprite(WheelEntity) as! WheelEntity).sprite.node.position.y <= max_y {
                makeWheel()
            }
        }
    }
    
    func setVisibility(node: SKSpriteNode) {
        if shouldHide(node) {
            node.removeFromParent()
            node.paused = true
        } else if shouldUnide(node) {
            scene.addChild(node)
            node.paused = false
        }
    }
    
    func setExistence(entity: GKEntity) {
        if let sprite = entity.componentForClass(SpriteComponent) {
            if shouldRemoveFromScene(sprite.node) {
                sprite.node.removeFromParent()
                remove(entity)
            }
        }
    }
    
    func makeWheel() {
        let wheel = WheelEntity(randomRadius: EntityManager._randomRadius)

        placeWheel(wheel)
        
        add(wheel)
    }
    
    func makePlayer() {
        let player = PlayerEntity()
        player.delegate = self
        add(player)
    }
    
    func makeHazard() {
        let size = CGSize(width: scene.frame.width, height: scene.frame.height)
        
        var position = CGPoint()
        position.x = scene.LEFT_EDGE + scene.frame.width / 2
        position.y = scene.camera!.position.y - scene.size.height * 2
        
        let hazard = HazardEntity(size: size, position: position)
        
        add(hazard)
    }
    
    func detachFromWheel() {
        physics.detachPlayerFromWheel()
    }
    
    func placeWheel(entity: GKEntity) {
        if let node = entity.componentForClass(SpriteComponent)?.node {
            node.position.x = getRandomX(entity)
            node.position.y = getInitialY()
            
            _adjustWheelPosition(entity as! WheelEntity)
        }
    }
    
    func mark(pos: CGPoint) {
        let rect = CGRectMake(0, 0, 2, 2)
        let sq = SKShapeNode.init(rect: rect)
        sq.fillColor = SKColor.redColor()
        sq.strokeColor = SKColor.clearColor()
        sq.position = pos
        sq.zPosition = 100000
        scene.addChild(sq)
    }
    
    private func _adjustWheelPosition (wheel: WheelEntity) {
        var ok = true
        
        if let node = wheel.componentForClass(SpriteComponent)?.node {
            let searchRadius = CGFloat(EntityManager._randomRadius.highestValue) + wheel.radius + 1
            let nearbyWheels = getObjectAround(wheel, inRadius: searchRadius)
            
            for w in nearbyWheels {
                if distanceBetweenObjects(wheel, w) < MIN_OBJ_DISTANCE {
                    ok = false
                    break
                }
            }
            
            if !ok {
                mark(node.position)
                node.position.y += 5
                _adjustWheelPosition(wheel)
            } else {
                node.position.y = getRandomY(wheel)!
            }
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
    
    func getRandomY(entity: GKEntity) -> CGFloat? {
        if let node = entity.componentForClass(SpriteComponent)?.node {
            let min = Int(node.position.y)
            let max = min + Int(MAX_OBJ_DISTANCE) - Int(node.size.height)/2
            
            let rand = GKRandomDistribution(lowestValue: min, highestValue: max)
            
            return CGFloat(rand.nextInt())
        }
        
        return nil
    }
    
    func distanceBetweenObjects(lhs: GKEntity, _ rhs: GKEntity) -> CGFloat {
        let o1 = lhs.componentForClass(SpriteComponent)!
        let o2 = rhs.componentForClass(SpriteComponent)!
        
        let dist = distanceBetweenPoints(o1.node.position, o2.node.position)
        //print(MAX_OBJ_DISTANCE, dist, o1.node.frame.width/2, o2.node.frame.width/2)
        return dist - o1.node.frame.width/2 - o2.node.frame.width/2
    }
    
    func getObjectAround(obj: GKEntity, inRadius: CGFloat) -> [GKEntity] {
        return entities.filter { el in
            return distanceBetweenObjects(obj, el) <= inRadius
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
    
    func positionPlayer() {
        let player = entities.filter { ent in
            return ent.isMemberOfClass(PlayerEntity)
        } [0]
        
        let wheels = getObjectAround(player, inRadius: CGFloat(EntityManager._randomRadius.highestValue) + MAX_OBJ_DISTANCE)
        
        let closestWheel = wheels.sort {a, b in
            let pos1 = a.componentForClass(SpriteComponent)!.node.position
            let pos2 = b.componentForClass(SpriteComponent)!.node.position
            
            let p1 = abs(pos1.x) + abs(pos1.y)
            let p2 = abs(pos2.x) + abs(pos2.y)
            
            return p1 < p2
        } [0]
        
        let playerNode = player.componentForClass(SpriteComponent)!.node
        playerNode.position.x = closestWheel.componentForClass(SpriteComponent)!.node.position.x
        playerNode.position.y = closestWheel.componentForClass(SpriteComponent)!.node.position.y + playerNode.size.height
    }
    
    func shouldRemoveFromScene (node: SKNode) -> Bool {
        return node.position.y < (hazard.sprite.position.y - hazard.sprite.size.height/2)
    }
    
    func shouldHide (node: SKNode) -> Bool {
        let pos = node.position
        
        return node.parent != nil &&
            pos.y < (scene.camera!.position.y - scene.frame.size.height) ||
            pos.y > (scene.camera!.position.y + scene.frame.size.height)
    }
    
    func shouldUnide (node: SKNode) -> Bool {
        let pos = node.position
        
        return node.parent == nil &&
            pos.y > (scene.camera!.position.y - scene.frame.size.height) &&
            pos.y < (scene.camera!.position.y + scene.frame.size.height)
    }
}