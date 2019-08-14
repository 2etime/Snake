import MetalKit

class Engine {
    private static var _device: MTLDevice!
    public static var Device: MTLDevice { return self._device }
    
    private static var _commandQueue: MTLCommandQueue!
    public static var CommandQueue: MTLCommandQueue { return self._commandQueue }
    
    private static var _defaultLibrary: MTLLibrary!
    public static var DefaultLibrary: MTLLibrary { return self._defaultLibrary }
    
    // Starts the engine
    public static func Ignite(_ device: MTLDevice) {
        self._device = device
        self._commandQueue = device.makeCommandQueue()
        self._defaultLibrary = device.makeDefaultLibrary()
    }
    
}
