import MetalKit


class Scene: Node {
    public static var DidTick: Bool = false

    var sceneConstants = SceneConstants()
    var apple: Apple!
    var snake: Snake!

    override init() {
        super.init()
        
        apple = Apple(posX: Float(Int.random(in: 0..<Int(GameSettings.GridCellsWide - 1))),
                      posY: Float(Int.random(in: 0..<Int(GameSettings.GridCellsHigh - 1))))
        
        snake = Snake()
        
        let projectionMatrix = matrix_float4x4.orthographic(width: GameSettings.GridCellsWide,
                                                            height: GameSettings.GridCellsHigh,
                                                            near: -1.0, far: 1.0)
        sceneConstants.projectionMatrix = projectionMatrix

        addChild(Grid())
        addChild(apple)
        
        addChild(snake)
    }
    
    func checkCollisions() {
        if(snake.headGridPosition == apple.gridPosition) {
            apple.move()
        }
        
        if(snake.hitSomething) {
            snake.stop()
        }
    }
    
    override func update(deltaTime: Float) {
        checkCollisions()
        
        super.update(deltaTime: deltaTime)
    }
    
    override func render(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setVertexBytes(&sceneConstants, length: SceneConstants.stride, index: 1)
        
        super.render(renderCommandEncoder)
    }
    
}
