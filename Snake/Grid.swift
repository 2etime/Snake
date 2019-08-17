
import MetalKit

class Grid: GameObject {
    override var renderPipelineStateType: RenderPipelineStateTypes { return .GridBackground }
    private var _totalTime: Float = 0.0
    private var _mesh: SquareMesh!
    
    init() {
        super.init(mesh: SquareMesh())
        _mesh = SquareMesh()
        
        let scale = float3(GameSettings.GridCellsWide,
                           GameSettings.GridCellsHigh, 1.0)
        self.setScale(scale)
    }
    
    override func doUpdate(deltaTime: Float) {
        _totalTime += deltaTime
    }
    
    override func render(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setFragmentBytes(&_totalTime, length: Float.stride, index: 0)
        super.render(renderCommandEncoder)
    }
}

class GridLines: GameObject {
    private var _gridConstants = GridConstants()
    override var renderPipelineStateType: RenderPipelineStateTypes { return .Grid }
    
    private var _mesh: SquareMesh!
    
    init() {
        super.init(mesh: SquareMesh())
        _mesh = SquareMesh()
        
        var scale = float3(GameSettings.GridCellsWide,
                           GameSettings.GridCellsHigh, 1.0)
        
        scale *= (1 - GameSettings.GridLinesWidth) // scale to match border
        self.setScale(scale)
        
        _gridConstants.cellsWide = GameSettings.GridCellsWide
        _gridConstants.cellsHigh = GameSettings.GridCellsHigh
    }
    
    override func doUpdate(deltaTime: Float) {
        self._gridConstants.totalGameTime += deltaTime
    }
    
    override func render(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setFragmentBytes(&_gridConstants, length: GridConstants.stride, index: 1)
        super.render(renderCommandEncoder)
    }
}
