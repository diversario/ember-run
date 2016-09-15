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
    unowned let scene: GameScene
    let physics: PhysicsEntity
    var entities = Set<GKEntity>()
    
    private var _lastUpdateTime: TimeInterval = 0
    
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
            return ent.isMember(of: PlayerEntity.self)
        } [0] as! PlayerEntity
    }
    
    var hazard: HazardEntity {
        return entities.filter { ent in
            return ent.isMember(of: HazardEntity.self)
            } [0] as! HazardEntity
    }
    
    func add(_ entity: GKEntity) {
        if let sprite = entity.component(ofType: SpriteComponent.self) {
            scene.addChild(sprite.node)
        }
        
        entities.insert(entity)
    }
    
    func remove(_ entity: GKEntity) {
        entities.remove(entity)
    }
    
    func update (_ currentTime: CFTimeInterval) {
        let deltaTime = currentTime - _lastUpdateTime
        _lastUpdateTime = currentTime
        
        player.updateWithDeltaTime(deltaTime, hazardEdge: hazard.edge)
        addWheels()
    }
    
    func addWheels () {
        let max_y = scene.camera!.position.y + scene.frame.size.height/2
        
        let highest_wheel = getHighestSprite(WheelEntity.self) as? WheelEntity
        
        if highest_wheel == nil {
            makeWheel()
        } else {
            while (getHighestSprite(WheelEntity.self) as! WheelEntity).sprite.node.position.y <= max_y {
                makeWheel()
            }
        }
    }
    
    func setVisibility(_ node: SKSpriteNode) {
        if shouldHide(node) {
            node.removeFromParent()
            node.isPaused = true
        } else if shouldUnide(node) {
            scene.addChild(node)
            node.isPaused = false
        }
    }
    
    func setExistence(_ entity: GKEntity) {
        if let sprite = entity.component(ofType: SpriteComponent.self) {
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
    
    func placeWheel(_ entity: GKEntity) {
        if let node = entity.component(ofType: SpriteComponent.self)?.node {
            node.position.x = getRandomX(entity)
            node.position.y = getInitialY()
            
            _adjustWheelPosition(entity as! WheelEntity)
        }
    }
    
    func mark(_ pos: CGPoint) {
        let rect = CGRect(x: 0, y: 0, width: 2, height: 2)
        let sq = SKShapeNode.init(rect: rect)
        sq.fillColor = SKColor.red
        sq.strokeColor = SKColor.clear
        sq.position = pos
        sq.zPosition = 100000
        scene.addChild(sq)
    }
    
    private func _adjustWheelPosition (_ wheel: WheelEntity) {
        var ok = true
        
        if let node = wheel.component(ofType: SpriteComponent.self)?.node {
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
        
        if let last_position = getHighestSprite(WheelEntity.self)?.component(ofType: SpriteComponent.self)?.node.position {
            y = last_position.y + 1
        } else {
            y = scene.frame.size.height / -2
        }
        
        return y
    }
    
    func getRandomX(_ entity: GKEntity) -> CGFloat {
        let wheel = entity.component(ofType: SpriteComponent.self)!.node
        let min = Int(wheel.frame.width / 2 + MIN_OBJ_DISTANCE - scene.frame.size.width / 2)
        let max = Int(scene.frame.size.width / 2 - MIN_OBJ_DISTANCE - wheel.frame.width / 2)
        
        let rand = GKRandomDistribution(lowestValue: min, highestValue: max)
        
        return CGFloat(rand.nextInt())
    }
    
    func getRandomY(_ entity: GKEntity) -> CGFloat? {
        if let node = entity.component(ofType: SpriteComponent.self)?.node {
            let min = Int(node.position.y)
            let max = min + Int(MAX_OBJ_DISTANCE) - Int(node.size.height)/2
            
            let rand = GKRandomDistribution(lowestValue: min, highestValue: max)
            
            return CGFloat(rand.nextInt())
        }
        
        return nil
    }
    
    func distanceBetweenObjects(_ lhs: GKEntity, _ rhs: GKEntity) -> CGFloat {
        let o1 = lhs.component(ofType: SpriteComponent.self)!
        let o2 = rhs.component(ofType: SpriteComponent.self)!
        
        let dist = distanceBetweenPoints(o1.node.position, o2.node.position)
        //print(MAX_OBJ_DISTANCE, dist, o1.node.frame.width/2, o2.node.frame.width/2)
        return dist - o1.node.frame.width/2 - o2.node.frame.width/2
    }
    
    func getObjectAround(_ obj: GKEntity, inRadius: CGFloat) -> [GKEntity] {
        return entities.filter { el in
            return distanceBetweenObjects(obj, el) <= inRadius
        }
    }
    
    func getHighestSprite(_ ofType: AnyClass) -> GKEntity? {
        var objects = entities.filter {el in
            return el.isKind(of: ofType) &&
                   el.component(ofType: SpriteComponent.self) != nil
        }
        
        if objects.count == 0 {
            return nil
        }
        
        objects.sort { (a, b) -> Bool in
            let n1 = a.component(ofType: SpriteComponent.self)!.node
            let n2 = b.component(ofType: SpriteComponent.self)!.node
            
            return n1.position.y > n2.position.y
        }
        
        return objects[0]
    }
    
    func positionPlayer() {
        let player = entities.filter { ent in
            return ent.isMember(of: PlayerEntity.self)
        } [0]
        
        let wheels = getObjectAround(player, inRadius: CGFloat(EntityManager._randomRadius.highestValue) + MAX_OBJ_DISTANCE)
        
        let closestWheel = wheels.sorted {a, b in
            let pos1 = a.component(ofType: SpriteComponent.self)!.node.position
            let pos2 = b.component(ofType: SpriteComponent.self)!.node.position
            
            let p1 = abs(pos1.x) + abs(pos1.y)
            let p2 = abs(pos2.x) + abs(pos2.y)
            
            return p1 < p2
        } [0]
        
        let playerNode = player.component(ofType: SpriteComponent.self)!.node
        playerNode.position.x = closestWheel.component(ofType: SpriteComponent.self)!.node.position.x
        playerNode.position.y = closestWheel.component(ofType: SpriteComponent.self)!.node.position.y + playerNode.size.height
    }
    
    func shouldRemoveFromScene (_ node: SKNode) -> Bool {
        return node.position.y < (hazard.sprite.position.y - hazard.sprite.size.height/2)
    }
    
    func shouldHide (_ node: SKNode) -> Bool {
        let pos = node.position
        
        return node.parent != nil &&
            pos.y < (scene.camera!.position.y - scene.frame.size.height) ||
            pos.y > (scene.camera!.position.y + scene.frame.size.height)
    }
    
    func shouldUnide (_ node: SKNode) -> Bool {
        let pos = node.position
        
        return node.parent == nil &&
            pos.y > (scene.camera!.position.y - scene.frame.size.height) &&
            pos.y < (scene.camera!.position.y + scene.frame.size.height)
    }
}
