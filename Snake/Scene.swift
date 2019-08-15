import MetalKit

class Scene: Node {
    var sceneConstants = SceneConstants()

    override init() {
        super.init()
        
        let projectionMatrix = matrix_float4x4.orthographic(width: GameSettings.GridCellsWide,
                                                            height: GameSettings.GridCellsHigh,
                                                            near: -1.0, far: 1.0)
        sceneConstants.projectionMatrix = projectionMatrix
        

        addChild(Grid())
        addChild(Apple(posX: Float(Int.random(in: 0..<Int(GameSettings.GridCellsWide - 1))),
                       posY: Float(Int.random(in: 0..<Int(GameSettings.GridCellsHigh - 1)))))
        
        addChild(Snake())
    }
    
    override func render(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setVertexBytes(&sceneConstants, length: SceneConstants.stride, index: 1)
        
        super.render(renderCommandEncoder)
    }
    
}
