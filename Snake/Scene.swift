import MetalKit

class Scene: Node {
    var sceneConstants = SceneConstants()

    override init() {
        super.init()

//        let projectionMatrix = matrix_float4x4.orthographic(width: GameSettings.GridCellsWide,
//                                                            height: GameSettings.GridCellsHigh,
//                                                            near: -1.0, far: 1.0)
        var projectionMatrix = matrix_float4x4.perspective(degreesFov: 90, aspectRatio: 1, near: -0.1, far: 1)
        projectionMatrix.translate(float3(0,0,-20))
        sceneConstants.projectionMatrix = projectionMatrix
        
        buildScene()
    }
    
    func buildScene() { }
    
    override func render(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setVertexBytes(&sceneConstants, length: SceneConstants.stride, index: 1)
        super.render(renderCommandEncoder)
    }
    
}
