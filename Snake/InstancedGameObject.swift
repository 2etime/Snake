import MetalKit

class InstancedGameObject: Node {
    private var _mesh: Mesh!

    internal var _nodes: [Node] = []
    private var _modelConstantBuffer: MTLBuffer!
    var renderPipelineStateType: RenderPipelineStateTypes { return  .AppleParticle }

    
    init(mesh: Mesh, instanceCount: Int) {
        super.init()
        self._mesh = mesh
        self._mesh.setInstanceCount(instanceCount)
        self.generateInstances(instanceCount)
        self.createBuffers(instanceCount)
    }
    
    func generateInstances(_ instanceCount: Int){
        for _ in 0..<instanceCount {
            _nodes.append(Node())
        }
    }
    
    func createBuffers(_ instanceCount: Int) {
        _modelConstantBuffer = Engine.Device.makeBuffer(length: ModelConstants.stride(instanceCount), options: [])
    }
    
    private func updateModelConstantsBuffer() {
        var pointer = _modelConstantBuffer.contents().bindMemory(to: ModelConstants.self, capacity: _nodes.count)
        for node in _nodes {
            pointer.pointee.modelMatrix = matrix_multiply(self.modelMatrix, node.modelMatrix)
            pointer = pointer.advanced(by: 1)
        }
    }
    
    override func update(deltaTime: Float) {
        updateModelConstantsBuffer()
        super.update(deltaTime: deltaTime)
    }
    
    override func render(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStates.get(renderPipelineStateType))
        renderCommandEncoder.setVertexBuffer(_modelConstantBuffer, offset: 0, index: 2)
        _mesh.draw(renderCommandEncoder)
        super.render(renderCommandEncoder)
    }
}
