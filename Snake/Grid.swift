
import MetalKit

class Grid {
    private var _vertices: [Vertex] = []
    private var _indices: [UInt32] = []
    
    private var _vertexBuffer: MTLBuffer!
    private var _indexBuffer: MTLBuffer!
    
    private var _renderPipelineState: MTLRenderPipelineState!
    
    private var _modelConstants = ModelConstants()
    private var _gridConstants = GridConstants()
    
    init(cellsWide: Float, cellsHigh: Float) {
        buildMesh()
        buildRenderPipelineState()
        
        let scale = float3(cellsWide + 1.5, cellsHigh + 1.5, 1.0)
        _modelConstants.modelMatrix.scale(scale)
        
        _gridConstants.cellsWide = cellsWide
        _gridConstants.cellsHigh = cellsHigh
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
        let fragmentFunction = Engine.DefaultLibrary.makeFunction(name: "grid_fragment_shader")
        
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
    
    public func update(deltaTime: Float) {
        self._gridConstants.totalGameTime += deltaTime
    }
    
    public func render(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(self._renderPipelineState)
        renderCommandEncoder.setVertexBuffer(_vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.setVertexBytes(&_modelConstants, length: ModelConstants.stride, index: 2)
        renderCommandEncoder.setFragmentBytes(&_gridConstants, length: GridConstants.stride, index: 1)
        renderCommandEncoder.drawIndexedPrimitives(type: .triangle,
                                                   indexCount: self._indices.count,
                                                   indexType: .uint32,
                                                   indexBuffer: self._indexBuffer,
                                                   indexBufferOffset: 0)
    }
}
