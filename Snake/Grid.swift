
import MetalKit

class Grid: Node {
    private var _modelConstants = ModelConstants()
    private var _gridConstants = GridConstants()
    
    private var _mesh: SquareMesh!
    
    override init() {
        super.init()
        _mesh = SquareMesh()
        
        let scale = float3(GameSettings.GridCellsWide,
                           GameSettings.GridCellsHigh, 1.0)
        _modelConstants.modelMatrix.scale(scale)
        
        _gridConstants.cellsWide = GameSettings.GridCellsWide
        _gridConstants.cellsHigh = GameSettings.GridCellsHigh
    }
    
    override func update(deltaTime: Float) {
        self._gridConstants.totalGameTime += deltaTime
    }
    
    override func render(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStates.get(.Grid))
        renderCommandEncoder.setVertexBytes(&_modelConstants, length: ModelConstants.stride, index: 2)
        renderCommandEncoder.setFragmentBytes(&_gridConstants, length: GridConstants.stride, index: 1)
        
        _mesh.draw(renderCommandEncoder)
    }
}
