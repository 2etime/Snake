import MetalKit

class Snake: Node {
    
    override init() {
        super.init()
        
        for y in 0..<Int(GameSettings.GridCellsWide) {
            for x in 0..<Int(GameSettings.GridCellsWide) {
                addChild(SnakeSection(cellX: x, cellY: y))                
            }
        }

    }
    
}

class SnakeSection: GameObject {
    
    override var renderPipelineStateType: RenderPipelineStateTypes { return .Snake }
    
    init(cellX: Int, cellY: Int) {
        super.init(mesh: SquareMesh())
        setInitialValues(cellX: cellX, cellY: cellY)
    }
    
    private func setInitialValues(cellX: Int, cellY: Int) {
        let scale = (1 - GameSettings.GridLinesWidth) * 0.9
        self.setScale(scale)
        
        let x: Float = (Float(cellX) - (floor(GameSettings.GridCellsWide / 2))) * (1 - GameSettings.GridLinesWidth)
        let y: Float = (-Float(cellY) + (floor(GameSettings.GridCellsHigh / 2))) * (1 - GameSettings.GridLinesWidth)
        self.setPosition(float3(x, y, 0.0))
    }
    
}
