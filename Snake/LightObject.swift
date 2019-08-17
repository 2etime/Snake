import MetalKit

class LightManager {
    private var _lightObjects: [LightObject] = []
    
    func addLightObject(_ lightObject: LightObject) {
        self._lightObjects.append(lightObject)
    }
    
    private func gatherLightData()->[LightData] {
        var result: [LightData] = []
        for lightObject in _lightObjects {
            result.append(lightObject.lightData)
        }
        return result
    }
    
    func setLightData(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        var lightDatas = gatherLightData()
        var lightCount = lightDatas.count
        renderCommandEncoder.setFragmentBytes(&lightCount,
                                              length: Int32.size,
                                              index: 2)
        renderCommandEncoder.setFragmentBytes(&lightDatas,
                                              length: LightData.stride(lightCount),
                                              index: 3)
    }
}

class LightObject: GameObject {
    var lightData = LightData()
    
    override func update(deltaTime: Float) {
        self.lightData.position = self.getPosition()
        super.update(deltaTime: deltaTime)
    }
}

extension LightObject {
    // Light Color
    public func setLightColor(_ color: float3) { self.lightData.color = color }
    public func getLightColor()->float3 { return self.lightData.color }
}
