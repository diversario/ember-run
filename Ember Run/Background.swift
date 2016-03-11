import Foundation
import SpriteKit

class BackgroundTile: Tile {
    init () {
        let texture = SKTexture(imageNamed: "background")
        super.init(t: texture, c: SKColor.clearColor(), s: texture.size())
        
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