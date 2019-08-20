import MetalKit

class AppleAteParticles: InstancedGameObject {
    var totalTime: Float = 0.0
    var directions: [float3] = []
    var particleCount: Int = 10
    var textureArray: TextureArray!
    var textureSlices: [uint32] = [0,1,2,3,4]
    
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
            _nodes[i].setScale(0.5)
            _nodes[i].rotateZ(Float.random(in: 1..<90))
        }
        
        textureArray = TextureArray(arrayLength: 5)
        textureArray.setSlice(slice: 0, tex: Textures.get(.Apple0))
        textureArray.setSlice(slice: 1, tex: Textures.get(.Apple1))
        textureArray.setSlice(slice: 2, tex: Textures.get(.Apple2))
        textureArray.setSlice(slice: 3, tex: Textures.get(.Apple3))
        textureArray.setSlice(slice: 4, tex: Textures.get(.Apple4))
    }
    
    func doAnimation(cellX: Int, cellY: Int) {
        self._currentAnimationTime = 0
        self._doAnimation = true
        let screenPosition = Grid.getScreenPosition(cellX: cellX, cellY: cellY)
        startAnimation(posX: screenPosition.x, posY: screenPosition.y)
    }
    
    override func doUpdate(deltaTime: Float) {
        totalTime += deltaTime
        if(_doAnimation) {
            for (i, child) in _nodes.enumerated() {
                child.move(directions[i].x * 0.2, directions[i].y * 0.2, 0.0)
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
            renderCommandEncoder.setFragmentTexture(textureArray.texture, index: 0)
            renderCommandEncoder.setFragmentSamplerState(SamplerStates.get(.Less), index: 0)
            renderCommandEncoder.setVertexBytes(&textureSlices, length: uint32.size(5), index: 3)
            super.render(renderCommandEncoder)
        }
    }
    
}
