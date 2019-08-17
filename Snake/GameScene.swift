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
    
    func checkInput() {
        var nextDirection = snake.head.direction
        if(Keyboard.IsKeyPressed(.upArrow)) {
            nextDirection = float3(0,1,0)
        }
        if(Keyboard.IsKeyPressed(.downArrow)) {
            nextDirection = float3(0,-1,0)
        }
        if(Keyboard.IsKeyPressed(.leftArrow)) {
            nextDirection = float3(-1,0,0)
        }
        if(Keyboard.IsKeyPressed(.rightArrow)) {
            nextDirection = float3(1,0,0)
        }
        
        snake.setNextDirection(nextDirection: nextDirection)
    }
    
    override func doUpdate(deltaTime: Float) {
        checkInput()
        
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
            || snake.head.gridPositionString.contains("\(Int(GameSettings.GridCellsHigh))")
            || snake.head.gridPositionString.contains("\(Int(GameSettings.GridCellsHigh ))")) {
            GameSettings.GameState = .GameOver
        }
    }
}
