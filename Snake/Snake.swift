import MetalKit

class Body: Node {
    private var _mesh: SquareMesh!
    private var _modelConstants = ModelConstants()
    fileprivate var nextDirection = float2(0,0)
    
    private var _velocity: float2 = float2(1,0)
    
    private var _gridPosition: float2 = float2(0,0)
    var gridPosition: float2 {
        if(_gridPosition.x < 0 ||
            _gridPosition.y < 0 ||
            _gridPosition.x > GameSettings.GridCellsWide - 3 ||
            _gridPosition.y > GameSettings.GridCellsHigh - 3) {
            return float2(-1, -1)
        }
        return abs(float2(_gridPosition.x, _gridPosition.y))
    }
    
    var timePassed: Float = 1
    var shouldTick: Bool {
        if(timePassed.truncatingRemainder(dividingBy: floor(60 / GameSettings.SnakeSpeed)) == 0) {
            timePassed = 1
            return true
        }
        timePassed += 1
        return false
    }
    
    init(posX: Float, posY: Float) {
        super.init()
        
        self._mesh = SquareMesh()
        
        let x: Float = posX - floor(GameSettings.GridCellsWide / 2) + 1
        let y: Float = -posY + floor(GameSettings.GridCellsHigh / 2) - 1
        self.position = float3(x, y, 0.0)
        
        self._gridPosition = float2(posX, posY)
        
        self.scale = float3(0.90, 0.90, 1.0)
    }
    
    func checkInput() {
        if(Keyboard.IsKeyPressed(.upArrow)) {
            nextDirection = float2(0,1)
        }
        if(Keyboard.IsKeyPressed(.downArrow)) {
            nextDirection = float2(0,-1)
        }
        if(Keyboard.IsKeyPressed(.leftArrow)) {
            nextDirection = float2(-1,0)
        }
        if(Keyboard.IsKeyPressed(.rightArrow)) {
            nextDirection = float2(1,0)
        }
    }
    
    override func update(deltaTime: Float) {
        checkInput()
        
        if(shouldTick) {
            _velocity = nextDirection
        }else{
            _velocity = float2(0,0)
        }
        
        self.position.x += self._velocity.x
        self.position.y += self._velocity.y
        
        self._gridPosition.x += self._velocity.x
        self._gridPosition.y -= self._velocity.y
        
        _modelConstants.modelMatrix = modelMatrix
    }
    
    override func render(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStates.get(.Snake))
        renderCommandEncoder.setVertexBytes(&_modelConstants, length: ModelConstants.stride, index: 2)
        _mesh.draw(renderCommandEncoder)
    }
}

class Snake: Node {
    
    private var head: Body!
    public var headGridPosition: float2 {
        return head.gridPosition
    }
    var hitSomething: Bool {
        return head.gridPosition == float2(-1,-1)
    }
    
    override init() {
        super.init()
        
        head = Body(posX: 2, posY: 2)
        self.addChild(head)
    }
    
    func stop() {
        head.nextDirection = float2(0,0)
    }
    
}
