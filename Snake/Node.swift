import MetalKit

class Node {
    private var _position: float3 = float3(0,0,0)
    private var _rotation: float3 = float3(0,0,0)
    private var _scale: float3 = float3(1,1,1)
    var modelMatrix: matrix_float4x4 {
        var modelMatrix = matrix_identity_float4x4
        modelMatrix.translate(self._position)
        modelMatrix.rotate(angle: self._rotation.x, axis: X_AXIS)
        modelMatrix.rotate(angle: self._rotation.y, axis: Y_AXIS)
        modelMatrix.rotate(angle: self._rotation.z, axis: Z_AXIS)
        modelMatrix.scale(self._scale)
        return modelMatrix
    }
    
    private var _children: [Node] = []
    
    public func addChild(_ child: Node) {
        self._children.append(child)
    }
    
    func update(deltaTime: Float) {
        for child in _children {
            child.update(deltaTime: deltaTime)
        }
    }
    
    func render(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        for child in _children {
            child.render(renderCommandEncoder)
        }
    }
}

extension Node {
    var position: float3 {
        set { self._position = newValue }
        get { return self._position }
    }
    
    var rotation: float3 {
        set { self._rotation = newValue }
        get { return self._rotation }
    }
    
    var scale: float3 {
        set { self._scale = newValue }
        get { return self._scale }
    }
}
