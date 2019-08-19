import MetalKit

class Snake: Node {
    
    var timePassed: Float = 1
    var shouldUpdate: Bool {
        if(timePassed.truncatingRemainder(dividingBy: floor(60 / GameSettings.SnakeSpeed)) == 0) {
            timePassed = 1
            return true
        }
        timePassed += 1
        return false
    }
    
    private var _head: SnakeSection!
    public var head: SnakeSection { return self._head}
    private var _nextDirection: float3 = float3(1,0,0)
    private var _turns: [String: float3] = [:]
    var turnsToRemove: [String] = []
    override init() {
        super.init()
        
        addSection()
        addSection()
        addSection()
    }
    
    func getTail()->SnakeSection {
        if let tail = children[children.count - 1] as? SnakeSection {
            return tail
        }
        return head
    }
    
    func addSection() {
        if(_head == nil) {
            self._head = SnakeSection(cellX: Int(GameSettings.GridCellsWide / 2),
                                      cellY: Int(GameSettings.GridCellsHigh / 2),
                                      direction: _nextDirection)
            addChild(self._head)
        } else {
            let tail = getTail()
            let tailDir = ceil(tail.direction)
            var section: SnakeSection!
            if(tailDir.x == 1 && tailDir.y == 0) {
                section = SnakeSection(cellX: tail.gridPositionX - 1,
                                       cellY: tail.gridPositionY,
                                       direction: tail.direction)
            }
            
            if(tailDir.x == -1 && tailDir.y == 0) {
                section = SnakeSection(cellX: tail.gridPositionX + 1,
                                       cellY: tail.gridPositionY,
                                       direction: tail.direction)
            }
            
            if(tailDir.x == 0 && tailDir.y == 1) {
                section = SnakeSection(cellX: tail.gridPositionX,
                                       cellY: tail.gridPositionY + 1,
                                       direction: tail.direction)
            }
            
            if(tailDir.x == 0 && tailDir.y == -1) {
                section = SnakeSection(cellX: tail.gridPositionX,
                                       cellY: tail.gridPositionY - 1,
                                       direction: tail.direction)
            }
            
            addChild(section)
        }
    }
    
    func setNextDirection(nextDirection: float3) {
        self._nextDirection = nextDirection
        
        if(head.direction != nextDirection) {
            _head.setTurn(direction: _nextDirection)
            _turns.updateValue(_nextDirection, forKey: "\(_head.gridPositionString )")
        }
    }
    
    var gridPositions: [String: SnakeSection] = [:]
    override func doUpdate(deltaTime: Float) {
        gridPositions.removeAll()
        
        if(Keyboard.IsKeyPressed(.space)) {
            addSection()
        }
        
        if(shouldUpdate) {
            if(GameSettings.GameState != .GameOver) {
                if(_head.direction != _nextDirection) {
                    _turns.updateValue(_nextDirection, forKey: "\(_head.gridPositionString )")
                }
                
                for (i, child) in children.enumerated() {
                    if let section = child as? SnakeSection {
                        let key = "\(section.gridPositionString)"
                        if(_turns[key] != nil) {
                            let turn  = _turns[key]!
                            section.setTurn(direction: turn)
                            if(i == children.count - 1) {
                                _turns.removeValue(forKey: key)
                            }
                        }
                        section.doMove()
                        gridPositions.updateValue(section, forKey: key)
                    }
                }
            }
        }
    }
    
}

class SnakeSection: GameObject {
    override var renderPipelineStateType: RenderPipelineStateTypes { return .Snake }
    private var scalar: Float = (1 - GameSettings.GridLinesWidth)
    var direction: float3 = float3(1,0,0)
    var gridPositionX: Int = 0
    var gridPositionY: Int = 0
    var color = float4(0.7,0.3,0.7,1)
    var gridPositionString: String {
        return "(\(gridPositionX),\(gridPositionY))"
    }
    
    init(cellX: Int, cellY: Int, direction: float3) {
        super.init(mesh: SquareMesh())
        self.direction = direction
        self.gridPositionX = cellX
        self.gridPositionY = cellY
        setInitialValues(cellX: cellX, cellY: cellY)
    }
    
    private func setInitialValues(cellX: Int, cellY: Int) {
        let scale = scalar * 0.9
        self.setScale(scale)
        
        let x: Float = (Float(cellX) - (floor(GameSettings.GridCellsWide / 2))) * scalar
        let y: Float = (-Float(cellY) + (floor(GameSettings.GridCellsHigh / 2))) * scalar
        self.setPosition(float3(x, y, 0.0))
    }
    
    func setTurn(direction: float3) {
        self.direction = direction
    }
    
    func doMove() {
        let scalar = (1 - GameSettings.GridLinesWidth)
        let x: Float = (Float(gridPositionX) - (floor(GameSettings.GridCellsWide / 2))) * scalar
        let y: Float = (-Float(gridPositionY) + (floor(GameSettings.GridCellsHigh / 2))) * scalar
        self.setPosition(x, y, 0)
        gridPositionX += Int(round(direction.x)) 
        gridPositionY -= Int(round(direction.y))
        
        if(!GameSettings.SideWallsActive) {
            //Through the wall magic
            if(gridPositionX < 0) { gridPositionX = Int(GameSettings.GridCellsWide - 1) }
            if(gridPositionX > Int(GameSettings.GridCellsWide - 1)) { gridPositionX = 0 }
            if(gridPositionY < 0) { gridPositionY = Int(GameSettings.GridCellsHigh - 1) }
            if(gridPositionY > Int(GameSettings.GridCellsHigh - 1)) { gridPositionY = 0 }            
        }

    }
    
    override func render(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setFragmentBytes(&color, length: float4.size, index: 0)
        super.render(renderCommandEncoder)
    }
}
