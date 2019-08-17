import MetalKit

class GameScene: Scene {
    var apples: [Apple] = []
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
        addApple(count: 2)
    }
    
    func addApple(count: Int) {
        for _ in 0..<count {
            let apple = Apple()
            addLight(apple)
            apples.append(apple)
        }
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
        
        for apple in apples {
            if(snake.head.gridPositionString == apple.gridPositionString){
                score += 1
                snake.addSection()
                
                var applePositionGridString = apple.moveApple()
                while(snake.gridPositions[applePositionGridString] != nil) {
                    applePositionGridString = apple.moveApple()
                }
            }
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
