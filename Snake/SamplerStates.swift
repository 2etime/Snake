import MetalKit

enum SamplerStateTypes {
    case Less
}

class SamplerStates {
    private static var _library: [SamplerStateTypes: MTLSamplerState] = [:]
    
    public static func Initialize() {
        _library.updateValue(buildLessSamplerState(), forKey: .Less)
    }
    
    private static func buildLessSamplerState()->MTLSamplerState {
        let samplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor.compareFunction = .less
        samplerDescriptor.minFilter = .linear
        samplerDescriptor.magFilter = .linear
        return Engine.Device.makeSamplerState(descriptor: samplerDescriptor)!
    }
    
    public static func get(_ type: SamplerStateTypes)->MTLSamplerState {
        return self._library[type]!
    }
}
