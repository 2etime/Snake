import MetalKit

class GameObject: Node {
    private var _mesh: Mesh!
    private var _texture: MTLTexture!
    private var _modelConstants = ModelConstants()
    var gridPositionX: Int = 0
    var gridPositionY: Int = 0
    var renderPipelineStateType: RenderPipelineStateTypes {
        return _texture == nil ? .Basic : .Textured
    }
    var gridPositionString: String {
        return "(\(gridPositionX - 1),\(gridPositionY))"
    }
    private var _color: float4 = float4(1,1,1,1)
    
    init(mesh: Mesh) {
        super.init()
        self._mesh = mesh
    }
    
    override func update(deltaTime: Float) {
        self._modelConstants.modelMatrix = modelMatrix
        super.update(deltaTime: deltaTime)
    }
    
    override func render(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStates.get(renderPipelineStateType))
        renderCommandEncoder.setVertexBytes(&_modelConstants, length: ModelConstants.stride, index: 2)
        renderCommandEncoder.setFragmentBytes(&_color, length: float4.size, index: 0)
        if(_texture != nil) {
            renderCommandEncoder.setFragmentSamplerState(SamplerStates.get(.Less), index: 0)
            renderCommandEncoder.setFragmentTexture(_texture, index: 0)
        }
        _mesh.draw(renderCommandEncoder)
        super.render(renderCommandEncoder)
    }
}

extension GameObject {
    public func setColor(_ color: float4) { self._color = color }
    public func setTexture(_ texture: MTLTexture) { self._texture = texture }
}
