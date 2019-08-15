import MetalKit

class Mesh {
    private var _vertices: [Vertex] = []
    private var _indices: [UInt32] = []
    
    private var _vertexBuffer: MTLBuffer!
    private var _indexBuffer: MTLBuffer!
    
    init() {
        buildMesh()
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
    
    func draw(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setVertexBuffer(_vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.drawIndexedPrimitives(type: .triangle,
                                                   indexCount: self._indices.count,
                                                   indexType: .uint32,
                                                   indexBuffer: self._indexBuffer,
                                                   indexBufferOffset: 0)
    }
}
