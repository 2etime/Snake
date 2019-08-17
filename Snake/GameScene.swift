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
        if(Keyboard.IsKeyPressed(.upArrow) || Keyboard.IsKeyPressed(.w)) {
            nextDirection = float3(0,1,0)
        }
        if(Keyboard.IsKeyPressed(.downArrow) || Keyboard.IsKeyPressed(.s)) {
            nextDirection = float3(0,-1,0)
        }
        if(Keyboard.IsKeyPressed(.leftArrow) || Keyboard.IsKeyPressed(.a)) {
            nextDirection = float3(-1,0,0)
        }
        if(Keyboard.IsKeyPressed(.rightArrow) || Keyboard.IsKeyPressed(.d)) {
            nextDirection = float3(1,0,0)
        }
        if(nextDirection != snake.head.direction * -1) {
            snake.setNextDirection(nextDirection: nextDirection)
        }
    }
    
    var totalTime: Float = 0.0
    override func doUpdate(deltaTime: Float) {
        totalTime += deltaTime
        
        checkInput()
        
        if(snake.head.gridPositionString == apple1.gridPositionString){
            score += 1
            snake.addSection()
            apple1.moveApple()
        }
        
        if(snake.head.gridPositionString == apple2.gridPositionString){
            score += 1
            snake.addSection()
            apple2.moveApple()
        }
        
        if(snake.head.gridPositionString.contains("-1")
            || snake.head.gridPositionString.contains("\(Int(GameSettings.GridCellsHigh))")
            || snake.head.gridPositionString.contains("\(Int(GameSettings.GridCellsHigh))")) {
            GameSettings.GameState = .GameOver
        }
    }
    
    override func afterUpdate(deltaTime: Float) {
        if(snake.gridPositions[snake.head.gridPositionString] != nil){
            GameSettings.GameState = .GameOver
            snake.gridPositions[snake.head.gridPositionString]!.color = float4(1,0,0,1)
        }
    }
}
