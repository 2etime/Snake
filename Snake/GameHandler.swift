import MetalKit

public var CellsWide: Float = 41.0
public var CellsHigh: Float = 41.0

public var NextDirection = float2(0,0)

class GameHandler: NSObject, MTKViewDelegate {
    var grid: Grid = Grid(cellsWide: CellsWide, cellsHigh: CellsHigh)
    var snake: Snake = Snake(posX: 6, posY: 6)
    var sceneConstants = SceneConstants()
    
    init(view: MTKView) {
        super.init()
        
        updateScreenSize(view: view)
        
        let projectionMatrix = matrix_float4x4.orthographic(width: CellsWide, height: CellsHigh, near: -1.0, far: 1.0)
        sceneConstants.projectionMatrix = projectionMatrix
    }
    
    public func updateScreenSize(view: MTKView){
        GameView.ScreenSize = float2(Float(view.bounds.width), Float(view.bounds.height))
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        updateScreenSize(view: view)
    }
    
    func checkInput() {
        if(Keyboard.IsKeyPressed(.upArrow)) {
            NextDirection = float2(0,1)
        }
        if(Keyboard.IsKeyPressed(.downArrow)) {
            NextDirection = float2(0,-1)
        }
        if(Keyboard.IsKeyPressed(.leftArrow)) {
            NextDirection = float2(-1,0)
        }
        if(Keyboard.IsKeyPressed(.rightArrow)) {
            NextDirection = float2(1,0)
        }
    }
    
    func draw(in view: MTKView) {
        let commandBuffer = Engine.CommandQueue.makeCommandBuffer()
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: view.currentRenderPassDescriptor!)
        
        checkInput()
        
        let deltaTime: Float = 1 / Float(view.preferredFramesPerSecond)
        grid.update(deltaTime: deltaTime)
        snake.update(deltaTime: deltaTime)
        
        renderCommandEncoder?.setVertexBytes(&sceneConstants, length: SceneConstants.stride, index: 1)
        grid.render(renderCommandEncoder!)
        snake.render(renderCommandEncoder!)
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(view.currentDrawable!)
        commandBuffer?.commit()
    }
}

