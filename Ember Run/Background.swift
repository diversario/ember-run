import Foundation
import SpriteKit
import UIKit


class BackgroundTile: Tile {
    var _size: CGSize!
    
    override var tileSize: CGSize {
        return _size
    }
    
    init () {
        let texture = SKTexture(imageNamed: "level background tile")
        let texture_size = texture.size()
        let height = texture_size.height * (UIScreen.mainScreen().bounds.width / texture_size.width)

        _size = CGSize(width: UIScreen.mainScreen().bounds.width, height: height)
        super.init(t: texture, c: SKColor.clearColor(), s: _size)
        
        _setAttributes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func _setAttributes () {
        zPosition = Z.BACKGROUND
        alpha = 1
    }
}


func makeTile () -> Tile {
    return BackgroundTile()
}


class Background {
    private unowned let _scene: SKScene
    private let _frame_size: CGSize
    
    private var _tiles: Tiler
    
    init(scene: SKScene) {
        self._scene = scene
        _frame_size = scene.size
        
        _tiles = Tiler(makeTile, atPosition: Position.CENTER, inScene: _scene)
    }
    
    deinit {
        print("DEINIT BACKGROUND")
    }
    
    func update () {
        _tiles.update()
    }
}