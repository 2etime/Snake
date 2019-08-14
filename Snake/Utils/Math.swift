import simd

public var X_AXIS: float3{
    return float3(1,0,0)
}

public var Y_AXIS: float3{
    return float3(0,1,0)
}

public var Z_AXIS: float3{
    return float3(0,0,1)
}

public func toRadians(_ degrees: Float)->Float{
    return (degrees / 180) * Float.pi
}

public func toDegrees(_ radians: Float) -> Float{
    return radians * (180 / Float.pi)
}

public var randomZeroToOne: Float{
    return Float(arc4random()) / Float(UINT32_MAX)
}

public func randomBounded(lowerBound: Int, upperBound: Int) -> Int {
    return lowerBound + Int(arc4random_uniform(UInt32(upperBound - lowerBound)))
}

func lerp(start: float3, end: float3, percent: Float)->float3{
    return (start + percent * (end - start))
}

extension matrix_float4x4 {
    
    mutating func translate(_ direction: float3) {
        var result = matrix_identity_float4x4
        
        let x: Float = direction.x
        let y: Float = direction.y
        let z: Float = direction.z
        
        result.columns = (
            float4(1, 0, 0, 0),
            float4(0, 1, 0, 0),
            float4(0, 0, 1, 0),
            float4(x, y, z, 1)
        )
        
        self = matrix_multiply(self, result)
    }
    
    mutating func rotate(_ angle: float3){
        self.rotate(angle: angle.x, axis: X_AXIS)
        self.rotate(angle: angle.y, axis: Y_AXIS)
        self.rotate(angle: angle.z, axis: Z_AXIS)
    }
    
    mutating func rotate(angle: Float, axis: float3){
        var result = matrix_identity_float4x4
        
        let x: Float = axis.x
        let y: Float = axis.y
        let z: Float = axis.z
        
        let c: Float = cos(angle)
        let s: Float = sin(angle)
        
        let mc: Float = (1 - c)
        
        let r1c1: Float = x * x * mc + c
        let r2c1: Float = x * y * mc + z * s
        let r3c1: Float = x * z * mc - y * s
        let r4c1: Float = 0.0
        
        let r1c2: Float = y * x * mc - z * s
        let r2c2: Float = y * y * mc + c
        let r3c2: Float = y * z * mc + x * s
        let r4c2: Float = 0.0
        
        let r1c3: Float = z * x * mc + y * s
        let r2c3: Float = z * y * mc - x * s
        let r3c3: Float = z * z * mc + c
        let r4c3: Float = 0.0
        
        let r1c4: Float = 0.0
        let r2c4: Float = 0.0
        let r3c4: Float = 0.0
        let r4c4: Float = 1.0
        
        result.columns = (
            float4(r1c1, r2c1, r3c1, r4c1),
            float4(r1c2, r2c2, r3c2, r4c2),
            float4(r1c3, r2c3, r3c3, r4c3),
            float4(r1c4, r2c4, r3c4, r4c4)
        )
        
        self = matrix_multiply(self, result)
    }
    
    mutating func scale(_ axis: float3){
        var result = matrix_identity_float4x4
        
        let x: Float = axis.x
        let y: Float = axis.y
        let z: Float = axis.z
        
        result.columns = (
            float4(x,0,0,0),
            float4(0,y,0,0),
            float4(0,0,z,0),
            float4(0,0,0,1)
        )
        
        self = matrix_multiply(self, result)
    }
    
    func getRotationMatrix()->matrix_float4x4 {
        var result = matrix_identity_float4x4
        
        //scale
        let s = float3(simd_length(self.columns.0), simd_length(self.columns.1), simd_length(self.columns.2))
        
        let a = self.columns.0.x
        let e = self.columns.0.y
        let i = self.columns.0.z
        
        let b = self.columns.1.x
        let f = self.columns.1.y
        let j = self.columns.1.z
        
        let c = self.columns.2.x
        let g = self.columns.2.y
        let k = self.columns.2.z
        
        result.columns = (
            float4(a / s.x, b / s.x, c / s.x, 0),
            float4(e / s.y, f / s.y, g / s.y, 0),
            float4(i / s.z, j / s.z, k / s.z, 0),
            float4(0, 0, 0, 1)
        )
        
        return result
    }
    
    func removeScaleFromMatrix()->matrix_float4x4 {
        //extract translation
        let t = float3(self.columns.3.x, self.columns.3.y, self.columns.3.z)
        
        var result = self.getRotationMatrix()
        result.translate(t)
        
        return result
    }
    
    //https://gamedev.stackexchange.com/questions/120338/what-does-a-perspective-projection-matrix-look-like-in-opengl
    static func perspective(degreesFov: Float, aspectRatio: Float, near: Float, far: Float)->matrix_float4x4{
        let fov = toRadians(degreesFov)
        
        let t: Float = tan(fov / 2)
        
        let x: Float = 1 / (aspectRatio * t)
        let y: Float = 1 / t
        let z: Float = -((far + near) / (far - near))
        let w: Float = -((2 * far * near) / (far - near))
        
        var result = matrix_identity_float4x4
        result.columns = (
            float4(x,  0,  0,   0),
            float4(0,  y,  0,   0),
            float4(0,  0,  z,  -1),
            float4(0,  0,  w,   0)
        )
        return result
    }
    
    static func orthographic(right: Float, left: Float, top: Float, bottom: Float, near: Float, far: Float)->matrix_float4x4{
        
        let r1c1: Float = 2.0 / (right - left)
        let r2c2: Float = 2.0 / (top - bottom)
        let r3c3: Float = -2.0 / (far - near)
        
        let r1c4: Float = -((right + left) / (right - left))
        let r2c4: Float = -((top + bottom) / (top - bottom))
        let r3c4: Float = -((far + near) / (far - near))
        
        var result = matrix_identity_float4x4
        result.columns = (
            float4(r1c1,  0,  0,  0),
            float4(0,  r2c2,  0,  0),
            float4(0,  0,  r3c3,  0),
            float4(r1c4,  r2c4,  r3c4,  1)
        )
        return result
    }
    
    static func orthographic(width: Float, height: Float, near: Float, far: Float)->matrix_float4x4{
        var result = matrix_identity_float4x4
        result.columns = (
            float4(2.0 / width,  0,  0,  0),
            float4(0,  2.0 / height,  0,  0),
            float4(0,  0,  1.0 / (far - near),  0),
            float4(0,  0,  -near / (far - near),  1)
        )
        return result
    }
    
    static func matrixLookAt(eye: float3, center: float3, up: float3)->matrix_float4x4{
        let z = normalize(eye - center)
        let x = normalize(cross(up, z))
        let y = cross(z, x)
        let t = float3(-dot(x, eye), -dot(y, eye), -dot(z, eye))
        
        var result = matrix_identity_float4x4
        result.columns = (
            float4(x.x,  y.x,  z.x,  0),
            float4(x.y,  y.y,  z.y,  0),
            float4(x.z,  y.z,  z.z,  0),
            float4(t.x,  t.y,  t.z,  1)
        )
        return result
    }
    
    func upperLeftMatrix()->matrix_float3x3{
        return matrix_float3x3(columns: (
            float3(columns.0.x, columns.0.y, columns.0.z),
            float3(columns.1.x, columns.1.y, columns.1.z),
            float3(columns.2.x, columns.2.y, columns.2.z)
        ))
    }
    
}

extension float4 {
    
    init(_ posXYZ: float3, _ posW: Float) {
        self.init()
        self.x = posXYZ.x
        self.y = posXYZ.y
        self.z = posXYZ.z
        self.w = posW
    }
    
    var xyz: float3 {
        return float3(self.x, self.y, self.z)
    }
    
}

extension Float {
    func roundTo(places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Float {
        return Float(arc4random()) / 0xFFF
    }
    
    /// Random float between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random float point number between 0 and n max
    public static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
}

extension float3 {
    var formattedString: String {
        return String("float3(\(self.x.roundTo(places: 2)), \(self.y.roundTo(places: 2)), \(self.z.roundTo(places: 2)))")
    }
}



