import MetalKit

class Scene: Node {
    var sceneConstants = SceneConstants()
    private var _lightManager = LightManager()

    override init() {
        super.init()

//        let projectionMatrix = matrix_float4x4.orthographic(width: GameSettings.GridCellsWide,
//                                                            height: GameSettings.GridCellsHigh,
//                                                            near: -1.0, far: 1.0)
        var projectionMatrix = matrix_float4x4.perspective(degreesFov: 90, aspectRatio: 1, near: -0.1, far: 1)
        let translate = GameSettings.GridCellsWide > GameSettings.GridCellsHigh ? GameSettings.GridCellsWide : GameSettings.GridCellsHigh
        projectionMatrix.translate(float3(0,0,-Float(translate / 2)))
        sceneConstants.projectionMatrix = projectionMatrix
        
        buildScene()
    }
    
    func addLight(_ lightObject: LightObject) {
        self.addChild(lightObject)
        _lightManager.addLightObject(lightObject)
    }
    
    func buildScene() { }
    
    override func render(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setVertexBytes(&sceneConstants, length: SceneConstants.stride, index: 1)
        _lightManager.setLightData(renderCommandEncoder)
        super.render(renderCommandEncoder)
    }
    
}
