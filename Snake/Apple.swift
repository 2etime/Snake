import MetalKit

class Apple: LightObject {
    override var renderPipelineStateType: RenderPipelineStateTypes { return .Textured }
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
        setLightColor(float3(1,0,0))
        _ = moveApple()
    }
    
    public func moveApple()->String {
        let cellX: Int = Int.random(in: 0..<(Int(GameSettings.GridCellsWide) - 2))
        let cellY: Int = Int.random(in: 0..<(Int(GameSettings.GridCellsWide) - 2))
        let screenPosition = Grid.getScreenPosition(cellX: cellX, cellY: cellY) * scalar
        self.setPosition(screenPosition)
        
        self.gridPositionX = cellX
        self.gridPositionY = cellY
        return gridPositionString
    }
    
    override func render(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setFragmentSamplerState(SamplerStates.get(.Less), index: 0)
        renderCommandEncoder.setFragmentTexture(_texture, index: 0)
        super.render(renderCommandEncoder)
    }
}
