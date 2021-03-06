import MetalKit

class GameHandler: NSObject, MTKViewDelegate {
    var scene: Scene!
    
    var inflightSemaphore = DispatchSemaphore(value: 3)
    
    init(view: MTKView) {
        super.init()
        
        RenderPipelineStates.Initialize()
        
        SamplerStates.Initialize()
        
        Textures.Initialize()
        
        updateScreenSize(view: view)
        
        scene = GameScene()
    }
    
    public func updateScreenSize(view: MTKView){
        GameView.ScreenSize = float2(Float(view.bounds.width), Float(view.bounds.height))
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        updateScreenSize(view: view)
    }
    
    func draw(in view: MTKView) {
//        _ = inflightSemaphore.wait(timeout: .distantFuture)
        
        let commandBuffer = Engine.CommandQueue.makeCommandBuffer()
//        commandBuffer?.addCompletedHandler({ (buffer) in
//            self.inflightSemaphore.signal()
//        })
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: view.currentRenderPassDescriptor!)
    
        let deltaTime: Float = 1 / Float(view.preferredFramesPerSecond)
        scene.update(deltaTime: deltaTime)
        
        scene.render(renderCommandEncoder!)
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(view.currentDrawable!)
        commandBuffer?.commit()
    }
}

