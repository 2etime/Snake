
import MetalKit

class Snake {
    private var _vertices: [Vertex] = []
    private var _indices: [UInt32] = []
    
    private var _vertexBuffer: MTLBuffer!
    private var _indexBuffer: MTLBuffer!
    
    private var _renderPipelineState: MTLRenderPipelineState!
    
    private var _modelConstants = ModelConstants()
    
    private var _speed: Float = 8.0
    private var _velocity: float2 = float2(1,0)
    
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
    
    var timePassed: Float = 1
    var shouldTick: Bool {
        if(timePassed.truncatingRemainder(dividingBy: floor(60 / _speed)) == 0) {
            timePassed = 1
            return true
        }
        timePassed += 1
        return false
    }
    
    init(posX: Float, posY: Float) {
        buildMesh()
        buildRenderPipelineState()
        
        self._position = float3(posX - floor(CellsWide / 2) + 1, -posY + floor(CellsWide / 2) - 1, 0.0)
        self._scale = float3(0.90, 0.90, 1.0)
    }
    
    private func buildMesh() {
        self._vertices.append(Vertex(position: float3( 0.5, 0.5, 0), textureCoordinate: float2(1,0))) // Top Right
        self._vertices.append(Vertex(position: float3(-0.5, 0.5, 0), textureCoordinate: float2(0,0))) // Top Left
        self._vertices.append(Vertex(position: float3(-0.5,-0.5, 0), textureCoordinate: float2(0,1))) // Bottom Left
        self._vertices.append(Vertex(position: float3( 0.5,-0.5, 0), textureCoordinate: float2(1,1))) // Bottom Right
        
        self._indices.append(contentsOf: [ 0,1,2,    0,2,3 ])
        
        self._vertexBuffer = Engine.Device.makeBuffer(bytes: self._vertices, length: Vertex.stride(self._vertices.count), options: [])
        self._indexBuffer = Engine.Device.makeBuffer(bytes: self._indices, length: UInt32.stride(self._indices.count), options: [])
    }
    
    private func buildRenderPipelineState() {
        let vertexFunction = Engine.DefaultLibrary.makeFunction(name: "basic_vertex_shader")
        let fragmentFunction = Engine.DefaultLibrary.makeFunction(name: "snake_fragment_shader")
        
        let vertexDescriptor = MTLVertexDescriptor()
        
        // Position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].offset = 0
        
        // Texture Coordinate
        vertexDescriptor.attributes[1].format = .float2
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].offset = float3.size
        
        vertexDescriptor.layouts[0].stride = Vertex.stride
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = EngineSettings.MainPixelFormat
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        do {
            self._renderPipelineState = try Engine.Device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch {
            print("ERROR::CREATING::RENDERPIPELINESTATE::\(error)")
        }
    }
    
    private func updateConstants() {
        
    }
    
    public func update(deltaTime: Float) {
        if(shouldTick) {
            _velocity = NextDirection
        }else{
            _velocity = float2(0,0)
        }
        
        self._position.x += self._velocity.x
        self._position.y += self._velocity.y
        
        _modelConstants.modelMatrix = modelMatrix
    }
    
    public func render(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(self._renderPipelineState)
        renderCommandEncoder.setVertexBuffer(_vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.setVertexBytes(&_modelConstants, length: ModelConstants.stride, index: 2)
        renderCommandEncoder.drawIndexedPrimitives(type: .triangle,
                                                   indexCount: self._indices.count,
                                                   indexType: .uint32,
                                                   indexBuffer: self._indexBuffer,
                                                   indexBufferOffset: 0)
    }
}
