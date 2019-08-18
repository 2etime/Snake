import MetalKit

enum RenderPipelineStateTypes {
    case Snake
    case Grid
    case GridBackground
    case Apple
    case Intanced
}

class RenderPipelineStates {
    private static var _library: [RenderPipelineStateTypes: MTLRenderPipelineState] = [:]
    
    public static func Initialize() {
        _library.updateValue(buildSnakeRenderPipelineState(), forKey: .Snake)
        _library.updateValue(buildGridRenderPipelineState(), forKey: .Grid)
        _library.updateValue(buildGridBackgroundRenderPipelineState(), forKey: .GridBackground)
        _library.updateValue(buildAppleRenderPipelineState(), forKey: .Apple)
        _library.updateValue(buildInstancedRenderPipelineState(), forKey: .Intanced)
    }
    
    private static func buildInstancedRenderPipelineState()->MTLRenderPipelineState {
        let vertexFunction = Engine.DefaultLibrary.makeFunction(name: "instanced_vertex_shader")
        let fragmentFunction = Engine.DefaultLibrary.makeFunction(name: "basic_fragment_shader")
        
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
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = GameSettings.MainPixelFormat
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        var renderPipelineState: MTLRenderPipelineState!
        do {
            renderPipelineState = try Engine.Device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch {
            print("ERROR::CREATING::RENDERPIPELINESTATE::\(error)")
        }
        return renderPipelineState
    }
    
    
    private static func buildAppleRenderPipelineState()->MTLRenderPipelineState {
        let vertexFunction = Engine.DefaultLibrary.makeFunction(name: "basic_vertex_shader")
        let fragmentFunction = Engine.DefaultLibrary.makeFunction(name: "apple_fragment_shader")
        
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
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = GameSettings.MainPixelFormat
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        var renderPipelineState: MTLRenderPipelineState!
        do {
            renderPipelineState = try Engine.Device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch {
            print("ERROR::CREATING::RENDERPIPELINESTATE::\(error)")
        }
        return renderPipelineState
    }
    
    private static func buildGridRenderPipelineState()->MTLRenderPipelineState {
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
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = GameSettings.MainPixelFormat
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        var renderPipelineState: MTLRenderPipelineState!
        do {
            renderPipelineState = try Engine.Device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch {
            print("ERROR::CREATING::RENDERPIPELINESTATE::\(error)")
        }
        return renderPipelineState
    }
    
    private static func buildGridBackgroundRenderPipelineState()->MTLRenderPipelineState {
        let vertexFunction = Engine.DefaultLibrary.makeFunction(name: "basic_vertex_shader")
        let fragmentFunction = Engine.DefaultLibrary.makeFunction(name: "grid_background_fragment_shader")
        
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
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = GameSettings.MainPixelFormat
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        var renderPipelineState: MTLRenderPipelineState!
        do {
            renderPipelineState = try Engine.Device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch {
            print("ERROR::CREATING::RENDERPIPELINESTATE::\(error)")
        }
        return renderPipelineState
    }
    
    
    private static func buildSnakeRenderPipelineState()->MTLRenderPipelineState {
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
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = GameSettings.MainPixelFormat
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        var renderPipelineState: MTLRenderPipelineState!
        do {
            renderPipelineState = try Engine.Device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch {
            print("ERROR::CREATING::RENDERPIPELINESTATE::\(error)")
        }
        return renderPipelineState
    }
    
    public static func get(_ type: RenderPipelineStateTypes)->MTLRenderPipelineState {
        return self._library[type]!
    }
}
