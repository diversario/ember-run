import Foundation
import SpriteKit
import UIKit


class BackgroundTile: Tile {
    var _size: CGSize!
    
    override var tileSize: CGSize {
        return _size
    }
    
    init () {
        let texture = SKTexture(imageNamed: "level-background-tile")
        let texture_size = texture.size()
        let height = texture_size.height * (UIScreen.main.bounds.width / texture_size.width)

        _size = CGSize(width: UIScreen.main.bounds.width, height: height)
        super.init(t: texture, c: SKColor.clear, s: _size)
        
        _setAttributes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func _setAttributes () {
        zPosition = Z.BACKGROUND
        alpha = 1
    }
}


func makeTile () -> Tile {
    return BackgroundTile()
}


class Background {
    fileprivate unowned let _scene: GameScene
    fileprivate let _frame_size: CGSize
    
    fileprivate var _tiles: Tiler
    
    init(scene: GameScene) {
        self._scene = scene
        _frame_size = scene.size
        
        _tiles = Tiler(makeTile, atPosition: Position.center, inScene: _scene)
    }
    
    deinit {
        print("DEINIT BACKGROUND")
    }
    
    func update () {
        _tiles.update()
    }
}
