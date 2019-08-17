import MetalKit

class GameScene: Scene {
    var apple: Apple!
    var snake: Snake!
    var score: Int = 0
    
    override func buildScene() {
        addChild(Grid())
        addChild(GridLines())
        addSnake()
        addApple()
    }
    
    func addApple() {
        self.apple = Apple()
        addChild(apple)
    }
    
    func addSnake() {
        self.snake = Snake()
        addChild(snake)
    }
    
    override func doUpdate(deltaTime: Float) {
        if(snake.head.gridPositionString == apple.gridPositionString){
            score += 1
            snake.canAdd = true
            apple.moveApple()
        }
    }
    
    override func afterUpdate(deltaTime: Float) {
        
        
        
    }
}
