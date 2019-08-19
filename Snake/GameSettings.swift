import MetalKit

enum ClearColors {
    public static var Pink: MTLClearColor = MTLClearColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0)
    public static var Black: MTLClearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    public static var DarkGray: MTLClearColor = MTLClearColor(red: 0.01, green: 0.01, blue: 0.01, alpha: 1.0)
}

enum GameStates {
    case Running
    case GameOver
}

class GameSettings {
    public static var ClearColor: MTLClearColor = ClearColors.DarkGray
    public static var MainPixelFormat: MTLPixelFormat = .bgra8Unorm_srgb
    
    private static var _gridSize: float2 = float2(41,41)
    public static var GridCellsWide: Float { return _gridSize.x }
    public static var GridCellsHigh: Float { return _gridSize.y }
    public static var GridLinesWidth: Float = 0.05
    
    public static var SnakeSpeed: Float = 20.0
    public static var GameState: GameStates = .Running
    public static var SideWallsActive: Bool = false
}

