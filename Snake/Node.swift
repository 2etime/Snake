import MetalKit

class Node {
    private var _position: float3 = float3(0,0,0)
    private var _rotation: float3 = float3(0,0,0)
    private var _scale: float3 = float3(1,1,1)
    var parentModelMatrix = matrix_identity_float4x4
    var modelMatrix: matrix_float4x4 {
        var modelMatrix = matrix_identity_float4x4
        modelMatrix.translate(self._position)
        modelMatrix.rotate(angle: self._rotation.x, axis: X_AXIS)
        modelMatrix.rotate(angle: self._rotation.y, axis: Y_AXIS)
        modelMatrix.rotate(angle: self._rotation.z, axis: Z_AXIS)
        modelMatrix.scale(self._scale)
        return matrix_multiply(parentModelMatrix, modelMatrix)
    }
    
   var children: [Node] = []
    
    public func addChild(_ child: Node) {
        self.children.append(child)
    }
    
    func doUpdate(deltaTime: Float) { }
    
    func afterUpdate(deltaTime: Float) { }
    
    func update(deltaTime: Float) {
        doUpdate(deltaTime: deltaTime)
        for child in children {
            child.parentModelMatrix = modelMatrix
            child.update(deltaTime: deltaTime)
        }
        afterUpdate(deltaTime: deltaTime)
    }
    
    func render(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        for child in children {
            child.render(renderCommandEncoder)
        }
    }
}

extension Node {
    // Positioning and Movement
    func setPosition(_ position: float3){ self._position = position }
    func setPosition(_ x: Float, _ y: Float, _ z: Float){ self._position = float3(x, y, z) }
    func setPositionX(_ xPosition: Float) { self._position.x = xPosition }
    func setPositionY(_ yPosition: Float) { self._position.y = yPosition }
    func setPositionZ(_ zPosition: Float) { self._position.z = zPosition }
    func getPosition()->float3 { return self._position }
    func getPositionX()->Float { return self._position.x }
    func getPositionY()->Float { return self._position.y }
    func getPositionZ()->Float { return self._position.z }
    func move(_ x: Float, _ y: Float, _ z: Float){ self._position += float3(x,y,z) }
    func moveX(_ delta: Float){ self._position.x += delta }
    func moveY(_ delta: Float){ self._position.y += delta }
    func moveZ(_ delta: Float){ self._position.z += delta }
    
    // Rotating
    func setRotation(_ rotation: float3) { self._rotation = rotation }
    func setRotation(_ x: Float, _ y: Float, _ z: Float){ self._rotation = float3(x, y, z) }
    func setRotationX(_ xRotation: Float) { self._rotation.x = xRotation }
    func setRotationY(_ yRotation: Float) { self._rotation.y = yRotation }
    func setRotationZ(_ zRotation: Float) { self._rotation.z = zRotation }
    func getRotation()->float3 { return self._rotation }
    func getRotationX()->Float { return self._rotation.x }
    func getRotationY()->Float { return self._rotation.y }
    func getRotationZ()->Float { return self._rotation.z }
    func rotate(_ x: Float, _ y: Float, _ z: Float){ self._rotation += float3(x,y,z) }
    func rotateX(_ delta: Float){ self._rotation.x += delta }
    func rotateY(_ delta: Float){ self._rotation.y += delta }
    func rotateZ(_ delta: Float){ self._rotation.z += delta }
    
    // Scaling
    func setScale(_ scale: float3){ self._scale = scale }
    func setScale(_ x: Float, _ y: Float, _ z: Float){ self._scale = float3(x, y, z) }
    func setScale(_ scale: Float){setScale(float3(scale, scale, scale))}
    func setScaleX(_ scaleX: Float){ self._scale.x = scaleX }
    func setScaleY(_ scaleY: Float){ self._scale.y = scaleY }
    func setScaleZ(_ scaleZ: Float){ self._scale.z = scaleZ }
    func getScale()->float3 { return self._scale }
    func getScaleX()->Float { return self._scale.x }
    func getScaleY()->Float { return self._scale.y }
    func getScaleZ()->Float { return self._scale.z }
    func scaleX(_ delta: Float){ self._scale.x += delta }
    func scaleY(_ delta: Float){ self._scale.y += delta }
    func scaleZ(_ delta: Float){ self._scale.z += delta }
}
