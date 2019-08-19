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
    
    private let _startingPosition = int2(4,4)
    private var _head: SnakeSection!
    public var head: SnakeSection { return self._head}
    private var _nextDirection: float3 = float3(1,0,0)
    private var _turns: [String: float3] = [:]
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
            self._head = SnakeSection(cellX: Int(_startingPosition.x),
                                      cellY: Int(_startingPosition.y),
                                      direction: _nextDirection)
            self._head.setTexture(Textures.get(.SnakeHead))
            addChild(self._head)
        } else {
            let tail = getTail()
            if(tail.id != head.id) {
                tail.setTexture(Textures.get(.SnakeBody))                
            }
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
            section.setTexture(Textures.get(.SnakeTail))
            addChild(section)
        }
    }
    
    func setNextDirection(nextDirection: float3) {
        self._nextDirection = nextDirection
        
        if(head.direction != nextDirection) {
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
                        
                        let gridPositionsHead = gridPositions[head.gridPositionString]
                        let gridPositionsSection = gridPositions[section.gridPositionString]
                        if(section.id != head.id && gridPositionsHead?.gridPositionString == gridPositionsSection?.gridPositionString){
                            GameSettings.GameState = .GameOver
                            head.setTexture(Textures.get(.SnakeHeadDead))
                            gridPositions[head.gridPositionString]!.setColor(float4(1,0,0,1))
                        }
                        
                        gridPositions.updateValue(section, forKey: key)
                    }
                }
            }
        }
    }
    
}

class SnakeSection: GameObject {
    private var scalar: Float = (1 - GameSettings.GridLinesWidth)
    var direction: float3 = float3(1,0,0)
    
    init(cellX: Int, cellY: Int, direction: float3) {
        super.init(mesh: SquareMesh())
        setTurn(direction: direction)
        self.gridPositionX = cellX
        self.gridPositionY = cellY
        setInitialValues(cellX: cellX, cellY: cellY)
    }
    
    private func setInitialValues(cellX: Int, cellY: Int) {
        let scale = scalar
        self.setScale(scale)
        let screenPosition = Grid.getScreenPosition(cellX: cellX - Int(direction.x), cellY: cellY + Int(direction.y)) * scalar
        self.setPosition(screenPosition)
    }
    
    func setTurn(direction: float3) {
        self.direction = direction
        if(direction.x == 1) {
            self.setRotationZ(toRadians(90))
        } else if(direction.x == -1) {
            self.setRotationZ(-toRadians(90))
        } else if(direction.y == 1) {
            self.setRotationZ(toRadians(180))
        } else if(direction.y == -1) {
            self.setRotationZ(toRadians(0))
        }
    }
    
    func doMove() {
        let scalar = (1 - GameSettings.GridLinesWidth)
        let screenPosition = Grid.getScreenPosition(cellX: gridPositionX, cellY: gridPositionY) * scalar
        self.setPosition(screenPosition)

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
}
