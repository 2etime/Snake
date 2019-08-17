
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
        self.setScale(scale * 2)
    }
    
    override func doUpdate(deltaTime: Float) {
        _totalTime += deltaTime
        
        self.rotateZ(deltaTime)
    }
    
    override func render(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        var isOver: Bool = GameSettings.GameState == .GameOver
        
        renderCommandEncoder.setFragmentBytes(&_totalTime, length: Float.size, index: 0)
        renderCommandEncoder.setFragmentBytes(&isOver, length: Bool.size, index: 1)
        super.render(renderCommandEncoder)
    }
}

class GridLines: GameObject {
    private var _gridConstants = GridConstants()
    override var renderPipelineStateType: RenderPipelineStateTypes { return .Grid }
    
    private var _mesh: SquareMesh!
    private var _totalTime: Float = 0.0
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

    var shakeTime: Int = 1
    override func doUpdate(deltaTime: Float) {
        self._totalTime += deltaTime
        self._gridConstants.totalGameTime = _totalTime
    }
    
    override func render(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setFragmentBytes(&_gridConstants, length: GridConstants.stride, index: 1)
        super.render(renderCommandEncoder)
    }
}
