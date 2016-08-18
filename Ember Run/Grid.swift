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
    private let _scale: CGFloat // 10 points per cell
    private let _cell_diameter: CGFloat
    private var _values: [[Bool]]
    private var _offset_x: CGFloat
    private var _offset_y: CGFloat!
    
    init(width: Int, height: Int, scale: Int = 10) {
        _scale = CGFloat(scale)
        _cell_diameter = sqrt(pow(_scale, 2) + pow(_scale, 2))
        
        _values = []
        
        _offset_x = CGFloat(width) / 2
        
        let x = Int(ceil(Float(width)/Float(scale)))
        let y = Int(ceil(Float(height)/Float(scale)))
        
        // MARK: swap?
        for _ in 0...y {
            let row = Array(count: x, repeatedValue: false)
            _values.append(row)
        }
    }
    
    convenience init(rect: CGRect, scale: Int = 10) {
        self.init(width: Int(rect.width), height: Int(rect.height), scale: scale)
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
    
    func drawDebugCells(scene: SKScene) {
        for w in 0...width - 1 {
            for h in 0...height - 1 {
                if get(w, y: h) {
                    let rx = CGFloat(w) * _scale - _offset_x
                    let ry = CGFloat(h) * _scale - _offset_y
                    
                    print(rx, ry)
                    
                    let rect = SKShapeNode.init(rect: CGRectMake(rx, ry, _scale, _scale))
                    rect.fillColor = SKColor.redColor()
                    rect.alpha = 0.3
                    rect.zPosition = 10000
                    scene.addChild(rect)
                }
            }
        }
    }
    
    private func _calculateOffset(center: CGPoint, radius: CGFloat) {
        _offset_y = CGFloat(abs(floor(center.y - radius)))
    }
    
    func get(x: Int, y: Int) -> Bool {
        return _values[y][x]
    }
    
    func set(x: Int, y: Int, value: Bool) {
        if _values.count > y && _values[0].count > x {
            _values[y][x] = value
        } else {
            resizeY(y)
            resizeX(x)
            set(x, y: y, value: value)
        }
    }
    
    func on(x: Int, y: Int) {
        if x >= 0 && y >= 0 {
            set(x, y: y, value: true)
        }
    }
    
    func off(x: Int, y: Int) {
        set(x, y: y, value: false)
    }
    
    func resizeY(y: Int) {
        while _values.count <= y {
            let row = Array(count: y, repeatedValue: false)
            _values.append(row)
        }
    }
    
    func resizeX(x: Int) {
        for var row in _values {
            while row.count <= x {
                let cells = Array(count: x - row.count + 1, repeatedValue: false)
                row.appendContentsOf(cells)
            }
        }
    }
    
    func addCircle(original_center: CGPoint, radius: CGFloat) {
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
    
    private func getDistance(p1: CGPoint, p2: CGPoint) -> CGFloat {
        return abs(sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2)))
    }
}