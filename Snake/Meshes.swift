import MetalKit

class Mesh {
    private var _vertices: [Vertex] = []
    private var _indices: [UInt32] = []
    
    private var _vertexBuffer: MTLBuffer!
    private var _indexBuffer: MTLBuffer!
    
    init() {
        getVertices()
        self._indices = getIndices()
        buildBuffers()
    }
    
    func addVertex(position: float3,
                   textureCoordinate: float2) {
        self._vertices.append(Vertex(position: position, textureCoordinate: textureCoordinate))
    }
    
    func getVertices() {  }
    
    func getIndices()->[UInt32] { return [] }
    
    func buildBuffers() {
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

class SquareMesh: Mesh {
  
    override func getVertices() {
        addVertex(position: float3( 0.5, 0.5, 0), textureCoordinate: float2(1,0)) // Top Right
        addVertex(position: float3(-0.5, 0.5, 0), textureCoordinate: float2(0,0)) // Top Left
        addVertex(position: float3(-0.5,-0.5, 0), textureCoordinate: float2(0,1)) // Bottom Left
        addVertex(position: float3( 0.5,-0.5, 0), textureCoordinate: float2(1,1)) // Bottom Right
    }
    
    override func getIndices() -> [UInt32] {
        return [ 0,1,2,    0,2,3 ]
    }

}
