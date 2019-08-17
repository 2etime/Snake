import MetalKit

class Apple: GameObject {
    override var renderPipelineStateType: RenderPipelineStateTypes { return .Apple }
    private var _texture: MTLTexture!
    var gridPositionX: Int = 0
    var gridPositionY: Int = 0
    var gridPositionString: String { return "(\(gridPositionX),\(gridPositionY))" }
    private var scalar: Float = (1 - GameSettings.GridLinesWidth)
    
    init() {
        super.init(mesh: SquareMesh())
         _texture = Textures.get(.Apple)
        setInitialValues(cellX: 0, cellY: 0)
    }
    
    private func setInitialValues(cellX: Int, cellY: Int) {
        let scale = scalar * 0.9
        self.setScale(scale)
        
        moveApple()
    }
    
    public func moveApple() {
        let cellX: Int = Int.random(in: 0..<(Int(GameSettings.GridCellsWide) - 2))
        let cellY: Int = Int.random(in: 0..<(Int(GameSettings.GridCellsWide) - 2))
        let x: Float = (Float(cellX) - (floor(GameSettings.GridCellsWide / 2))) * scalar
        let y: Float = (-Float(cellY) + (floor(GameSettings.GridCellsHigh / 2))) * scalar
        self.setPosition(float3(x, y, 0.0))
        
        self.gridPositionX = cellX
        self.gridPositionY = cellY
    }
    
    override func render(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setFragmentSamplerState(SamplerStates.get(.Less), index: 0)
        renderCommandEncoder.setFragmentTexture(_texture, index: 0)
        super.render(renderCommandEncoder)
    }
}
