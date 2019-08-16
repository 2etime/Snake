import MetalKit

class GameScene: Scene {
    
    override func buildScene() {
        
        addChild(Grid())
        addChild(Snake())
    }
    
}
