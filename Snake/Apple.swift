import MetalKit

class Apple: Node {
    private var _modelConstants = ModelConstants()
    
    private var _gridPosition: float2 = float2(0,0)
    public var gridPosition: float2 {
        return _gridPosition
    }
    
    private var _mesh: SquareMesh!
    private var _texture: MTLTexture!
    
    init(posX: Float, posY: Float) {
        super.init()
        _mesh = SquareMesh()
        _texture = Textures.get(.Apple)
        
        setGridPosition(posX: posX, posY: posY)
        
        self._gridPosition = float2(posX, posY)
        
        self.scale = float3(0.90, 0.90, 1.0)
    }
    
    func setGridPosition(posX: Float, posY: Float) {
        self.position = float3(posX - floor(GameSettings.GridCellsWide / 2) + 1,
                               -posY + floor(GameSettings.GridCellsHigh / 2) - 1,
                               0.0)
        self._gridPosition = float2(posX, posY)
    }
    
    func move() {
        setGridPosition(posX: Float(Int.random(in: 0..<Int(GameSettings.GridCellsWide - 1))),
                        posY: Float(Int.random(in: 0..<Int(GameSettings.GridCellsHigh - 1))))
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
