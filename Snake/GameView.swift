import MetalKit

class GameView: MTKView {

    var gameHandler: GameHandler!
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.device = MTLCreateSystemDefaultDevice()
        
        Engine.Ignite(self.device!)
        
        self.gameHandler = GameHandler()
        
        self.clearColor = EngineSettings.ClearColor
        
        self.colorPixelFormat = EngineSettings.MainPixelFormat
        
        self.delegate = gameHandler
    }
    
}
