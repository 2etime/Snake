import MetalKit

class Snake: Node {
    private var _mesh: Mesh!
    private var _modelConstants = ModelConstants()
    private var _nextDirection = float2(0,0)
    
    private var _speed: Float = 8.0
    private var _velocity: float2 = float2(1,0)
    
    var timePassed: Float = 1
    var shouldTick: Bool {
        if(timePassed.truncatingRemainder(dividingBy: floor(60 / _speed)) == 0) {
            timePassed = 1
            return true
        }
        timePassed += 1
        return false
    }
    
    init(posX: Float, posY: Float) {
        super.init()
        
        self._mesh = Mesh()

        self.position = float3(posX - floor(GameSettings.GridCellsWide / 2) + 1,
                               -posY + floor(GameSettings.GridCellsHigh / 2) - 1,
                               0.0)
        
        self.scale = float3(0.90, 0.90, 1.0)
    }
    
    func checkInput() {
        if(Keyboard.IsKeyPressed(.upArrow)) {
            _nextDirection = float2(0,1)
        }
        if(Keyboard.IsKeyPressed(.downArrow)) {
            _nextDirection = float2(0,-1)
        }
        if(Keyboard.IsKeyPressed(.leftArrow)) {
            _nextDirection = float2(-1,0)
        }
        if(Keyboard.IsKeyPressed(.rightArrow)) {
            _nextDirection = float2(1,0)
        }
    }
    
    override func update(deltaTime: Float) {
        checkInput()
        
        if(shouldTick) {
            _velocity = _nextDirection
        }else{
            _velocity = float2(0,0)
        }
        
        self.position.x += self._velocity.x
        self.position.y += self._velocity.y
        
        _modelConstants.modelMatrix = modelMatrix
    }
    
    override func render(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStates.get(.Snake))
        renderCommandEncoder.setVertexBytes(&_modelConstants, length: ModelConstants.stride, index: 2)
        _mesh.draw(renderCommandEncoder)
    }
}
