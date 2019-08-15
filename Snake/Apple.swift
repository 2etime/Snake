import MetalKit

class Apple: Node {
    private var _modelConstants = ModelConstants()
    
    private var _mesh: SquareMesh!
    private var _texture: MTLTexture!
    
    init(posX: Float, posY: Float) {
        super.init()
        _mesh = SquareMesh()
        _texture = Textures.get(.Apple)
        
        self.position = float3(posX - floor(GameSettings.GridCellsWide / 2) + 1,
                               -posY + floor(GameSettings.GridCellsHigh / 2) - 1,
                               0.0)
        
        self.scale = float3(0.90, 0.90, 1.0)
    }
    
    override func update(deltaTime: Float) {
        
        _modelConstants.modelMatrix = modelMatrix
        
        super.update(deltaTime: deltaTime)
    }
    
    override func render(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStates.get(.Apple))
        renderCommandEncoder.setVertexBytes(&_modelConstants, length: ModelConstants.stride, index: 2)
        renderCommandEncoder.setFragmentSamplerState(SamplerStates.get(.Less), index: 0)
        renderCommandEncoder.setFragmentTexture(_texture, index: 0)
        
        _mesh.draw(renderCommandEncoder)
    }
}
