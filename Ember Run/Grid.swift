//
//  Grid.swift
//  Ember Run
//
//  Created by Ilya Shaisultanov on 8/14/16.
//  Copyright © 2016 Ilya Shaisultanov. All rights reserved.
//

import Foundation
import SpriteKit

class Grid {
    fileprivate let _scale: CGFloat // 10 points per cell
    fileprivate let _cell_diameter: CGFloat
    fileprivate var _values: [[Bool]]
    fileprivate var _offset_x: CGFloat
    fileprivate var _offset_y: CGFloat!
    
    fileprivate var _existingObjects = [(CGPoint, CGFloat)]()
    
    init(width: Int, height: Int, scale: Int = 10) {
        _scale = CGFloat(scale)
        _cell_diameter = sqrt(pow(_scale, 2) + pow(_scale, 2))
        
        _values = []
        
        _offset_x = CGFloat(width) / 2
        
        let x = Int(ceil(Float(width)/Float(scale)))
        let y = Int(ceil(Float(height)/Float(scale)))
        
        for _ in 0...y {
            let row = Array(repeating: false, count: x)
            _values.append(row)
        }
    }
    
    convenience init(rect: CGRect, scale: Int = 10) {
        self.init(width: Int(rect.width), height: Int(rect.height), scale: scale)
    }
    
    deinit {
        print("DEINIT GRID")
    }
    
    var values: [[Bool]] {
        return _values
    }
    
    var width: Int {
        return _values[0].count
    }
    
    var height: Int {
        return _values.count
    }
    
    fileprivate var _debug_h = 0
    
    func drawDebugCells(_ scene: SKScene) {
        if _debug_h <= height - 1 {
            for w in 0...width - 1 {
                for h in _debug_h...height - 1 {
                    if get(w, y: h) {
                        let rx = CGFloat(w) * _scale - _offset_x
                        let ry = CGFloat(h) * _scale - _offset_y
                        
                        let rect = SKShapeNode.init(rect: CGRect(x: rx, y: ry, width: _scale, height: _scale))
                        rect.fillColor = SKColor.red
                        rect.alpha = 0.3
                        rect.zPosition = 10000
                        scene.addChild(rect)
                    }
                }
            }
            
            _debug_h = height
        }
    }
    
    fileprivate func _calculateOffset(_ center: CGPoint, radius: CGFloat) {
        _offset_y = CGFloat(abs(floor(center.y - radius)))
    }
    
    func get(_ x: Int, y: Int) -> Bool {
        return _values[y][x]
    }
    
    func set(_ x: Int, y: Int, value: Bool) {
        if _values.count > y && _values[0].count > x {
            _values[y][x] = value
        } else {
            resizeY(y)
            resizeX(x)
            set(x, y: y, value: value)
        }
    }
    
    func on(_ x: Int, y: Int) {
        if x >= 0 && y >= 0 {
            set(x, y: y, value: true)
        }
    }
    
    func off(_ x: Int, y: Int) {
        set(x, y: y, value: false)
    }
    
    func resizeY(_ y: Int) {
        while _values.count <= y {
            let row = Array(repeating: false, count: y)
            _values.append(row)
        }
    }
    
    func resizeX(_ x: Int) {
        for var row in _values {
            while row.count <= x {
                let cells = Array(repeating: false, count: x - row.count + 1)
                row.append(contentsOf: cells)
            }
        }
    }
    
    func shouldIgnoreObject(_ center: CGPoint, radius: CGFloat) -> Bool {
        return _existingObjects.filter{$0.0 == center && $0.1 == radius}.count > 0
    }
    
    func _ignoreObject(_ center: CGPoint, radius: CGFloat) {
        _existingObjects.append((center, radius))
    }
    
    func addCircle(_ original_center: CGPoint, radius: CGFloat) {
        if shouldIgnoreObject(original_center, radius: radius) {
            return
        }
        
        _ignoreObject(original_center, radius: radius)
        
        if _offset_y == nil {
            _calculateOffset(original_center, radius: radius)
        }
        
        // ignore circles less than the half of cell diameter
        if radius <= _cell_diameter/2.0 {
            return
        }
        
        let center = CGPoint(x: original_center.x + _offset_x, y: original_center.y + _offset_y)
        
        let ll = (floor((center.x - radius)/_scale), floor((center.y - radius)/_scale))
        let ur = (floor((center.x + radius)/_scale), floor((center.y + radius)/_scale))
        
        //does this circle occupy one cell only?
        if abs(ll.0 - ur.0) == 1 && abs(ll.1 - ur.1) == 1 {
            on(Int(ll.0), y: Int(ll.1))
            return
        }
        
        // TODO: don't check/set cells twice
        // check all corners of every cell for overlap
        for x in Int(ll.0)...Int(ur.0) {
            for y in Int(ll.1)...Int(ur.1) {
                //TODO: also calc the diff between distance from corner to
                // center and if it's >= 1/2 cell size turn the cell on
                
                let ll = CGPoint(x: CGFloat(x) * _scale, y: CGFloat(y) * _scale)
                
                if getDistance(center, p2: ll) < radius {
                    on(x, y: y)
                    continue
                }
                
                let lr = CGPoint(x: CGFloat(x) * _scale + _scale, y: CGFloat(y) * _scale)
                
                if getDistance(center, p2: lr) < radius {
                    on(x, y: y)
                    continue
                }
                
                let ul = CGPoint(x: CGFloat(x) * _scale, y: CGFloat(y) * _scale + _scale)
                
                if getDistance(center, p2: ul) < radius {
                    on(x, y: y)
                    continue
                }
                
                let ur = CGPoint(x: CGFloat(x) * _scale + _scale, y: CGFloat(y) * _scale + _scale)
                
                if getDistance(center, p2: ur) < radius {
                    on(x, y: y)
                    continue
                }
            }
        }
    }
    
//    func findEmptySpace(near: CGPoint) -> CGPoint {
//        
//    }
    
    fileprivate func getDistance(_ p1: CGPoint, p2: CGPoint) -> CGFloat {
        return abs(sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2)))
    }
}
