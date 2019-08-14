import MetalKit

class GameHandler: NSObject, MTKViewDelegate {
    var grid: Grid = Grid(cellsWide: 40, cellsHigh: 40)
    var sceneConstants = SceneConstants()
    
    override init() {
        super.init()
        
        let projectionMatrix = matrix_float4x4.orthographic(width: 40, height: 40, near: -1.0, far: 1.0)
        sceneConstants.projectionMatrix = projectionMatrix
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // On Resize
    }
    
    func draw(in view: MTKView) {
        let commandBuffer = Engine.CommandQueue.makeCommandBuffer()
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: view.currentRenderPassDescriptor!)
        
        let deltaTime: Float = 1 / Float(view.preferredFramesPerSecond)
        grid.update(deltaTime: deltaTime)
        
        renderCommandEncoder?.setVertexBytes(&sceneConstants, length: SceneConstants.stride, index: 1)
        grid.render(renderCommandEncoder!)
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(view.currentDrawable!)
        commandBuffer?.commit()
    }
}

