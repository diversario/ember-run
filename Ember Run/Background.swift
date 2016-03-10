import Foundation
import SpriteKit

class BackgroundTile: Tile {
    private var _texture: SKTexture! = SKTexture(imageNamed: "background")
    
    override var tileSize: CGSize {
        return _texture.size()
    }
    
    convenience init(atPosition position: CGPoint) {
        self.init()
        self.position = position
    }
    
    init () {
        super.init(t: _texture, c: SKColor.clearColor(), s: _texture.size())
        
        _setAttributes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func _setAttributes () {
        zPosition = Z.BACKGROUND
        alpha = 0.5
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