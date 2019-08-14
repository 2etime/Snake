import MetalKit

enum ClearColors {
    public static var Pink: MTLClearColor = MTLClearColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0)
    public static var Black: MTLClearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    public static var DarkGray: MTLClearColor = MTLClearColor(red: 0.01, green: 0.01, blue: 0.01, alpha: 1.0)
}

class EngineSettings {
    public static var ClearColor: MTLClearColor = ClearColors.DarkGray
    public static var MainPixelFormat: MTLPixelFormat = .bgra8Unorm_srgb
}

