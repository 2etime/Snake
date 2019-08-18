import MetalKit

class AppleAteParticles: InstancedGameObject {
    var totalTime: Float = 0.0
    var directions: [float3] = []
    var particleCount: Int = 40
    
    private var _startingPosition: float3 = float3(0,0,0)
    private var _currentAnimationTime: Int = 0
    private var _doAnimation: Bool = false

    init() {
        super.init(mesh: SquareMesh(), instanceCount: particleCount)
        for i in 0..<particleCount {
            let randomDirection: float3 = float3(Float.random(in: -0.5..<0.5),
                                                 Float.random(in: -0.5..<0.5),
                                                 Float.random(in: -0.5..<0.5))

            directions.append(randomDirection)
            _nodes[i].setScaleX(0.1)
            _nodes[i].rotateZ(Float.random(in: 1..<90))
        }
    }
    
    func doAnimation(cellX: Int, cellY: Int) {
        self._currentAnimationTime = 0
        self._doAnimation = true
        let x: Float = (Float(cellX) - (floor(GameSettings.GridCellsWide / 2)))
        let y: Float = (-Float(cellY) + (floor(GameSettings.GridCellsHigh / 2)))
        startAnimation(posX: x, posY: y)
    }
    
    override func doUpdate(deltaTime: Float) {
        totalTime += deltaTime
        if(_doAnimation) {
            for (i, child) in _nodes.enumerated() {
                child.move(directions[i].x, directions[i].y, 0.0)
                child.rotateZ(deltaTime)
            }
            self._currentAnimationTime += 1
            
            if(_currentAnimationTime % 60 == 0){
                self._doAnimation = false
                finishAnimation()
            }
        }
    }
    
    private func startAnimation(posX: Float, posY: Float) {
        for i in 0..<particleCount {
            _nodes[i].setPosition(float3(posX,posY,0))
        }
    }
    
    private func finishAnimation() {
        for _ in 0..<particleCount {
            let randomDirection = float3(0.0, 0.0, 0.0)
            directions.append(randomDirection)
        }
    }
    
    override func render(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        if(_doAnimation) {
            renderCommandEncoder.setFragmentBytes(&_currentAnimationTime, length: uint32.size, index: 0)
            super.render(renderCommandEncoder)
        }
    }
    
}
