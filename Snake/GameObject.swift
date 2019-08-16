import MetalKit

class GameObject: Node {
    private var _mesh: Mesh!
    private var _modelConstants = ModelConstants()
    var renderPipelineStateType: RenderPipelineStateTypes { return .Snake }
    
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
        _mesh.draw(renderCommandEncoder)
        super.render(renderCommandEncoder)
    }
}
