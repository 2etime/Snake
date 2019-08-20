import MetalKit

class Apple: LightObject {
    private var scalar: Float = (1 - GameSettings.GridLinesWidth)
    
    init() {
        super.init(mesh: SquareMesh())
        setTexture(Textures.get(.Apple))
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
        let cellY: Int = Int.random(in: 0..<(Int(GameSettings.GridCellsHigh) - 2))
        let screenPosition = Grid.getScreenPosition(cellX: cellX, cellY: cellY) * scalar
        self.setPosition(screenPosition)
        
        self.gridPositionX = cellX
        self.gridPositionY = cellY
        return gridPositionString
    }
}
