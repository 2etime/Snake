import MetalKit

class GameScene: Scene {
    var apple1: Apple!
    var apple2: Apple!
    var snake: Snake!
    var score: Int = 0
    var grid: Grid!
    var gridLines: GridLines!
    
    override func buildScene() {
        self.grid = Grid()
        addChild(grid)
        
        self.gridLines = GridLines()
        addChild(gridLines)
        addSnake()
        addApple()
    }
    
    func addApple() {
        self.apple1 = Apple()
        addChild(apple1)
        
        self.apple2 = Apple()
        addChild(apple2)
    }
    
    func addSnake() {
        self.snake = Snake()
        addChild(snake)
    }
    
    override func doUpdate(deltaTime: Float) {
        if(snake.head.gridPositionString == apple1.gridPositionString){
            score += 1
            snake.canAdd = true
            apple1.moveApple()
        }
        
        if(snake.head.gridPositionString == apple2.gridPositionString){
            score += 1
            snake.canAdd = true
            apple2.moveApple()
        }
        
        if(snake.head.gridPositionString.contains("-1")
            || snake.head.gridPositionString.contains("\(Int(GameSettings.GridCellsHigh + 1))")
            || snake.head.gridPositionString.contains("\(Int(GameSettings.GridCellsHigh + 1))")) {
            GameSettings.GameState = .GameOver
        }
    }
}
