import MetalKit

enum TextureTypes{
    case None
    case Apple
    case SnakeHead
    case SnakeHeadDead
    case SnakeBody
    case SnakeTail
    case SnakeTurn
}

class Textures {
    private static var _library: [TextureTypes: Texture] = [:]
    
    public static func Initialize() {
        _library.updateValue(Texture("apple"), forKey: .Apple)
        _library.updateValue(Texture("SnakeHead"), forKey: .SnakeHead)
        _library.updateValue(Texture("SnakeHeadDead"), forKey: .SnakeHeadDead)
        _library.updateValue(Texture("SnakeBody"), forKey: .SnakeBody)
        _library.updateValue(Texture("SnakeTail"), forKey: .SnakeTail)
        _library.updateValue(Texture("SnakeTurn"), forKey: .SnakeTurn)
    }
    
    public static func get(_ type: TextureTypes)->MTLTexture {
        return self._library[type]!.texture
    }
}

class Texture {
    var texture: MTLTexture!
    
    init(_ textureName: String, ext: String = "png", origin: MTKTextureLoader.Origin = .topLeft){
        let textureLoader = TextureLoader(textureName: textureName, textureExtension: ext, origin: origin)
        let texture: MTLTexture = textureLoader.loadTextureFromBundle()
        setTexture(texture)
    }
    
    func setTexture(_ texture: MTLTexture){
        self.texture = texture
    }
}

class TextureLoader {
    private var _textureName: String!
    private var _textureExtension: String!
    private var _origin: MTKTextureLoader.Origin!
    
    init(textureName: String, textureExtension: String = "png", origin: MTKTextureLoader.Origin = .topLeft){
        self._textureName = textureName
        self._textureExtension = textureExtension
        self._origin = origin
    }
    
    public func loadTextureFromBundle()->MTLTexture{
        var result: MTLTexture!
        if let url = Bundle.main.url(forResource: _textureName, withExtension: self._textureExtension) {
            let textureLoader = MTKTextureLoader(device: Engine.Device)
            
            let options: [MTKTextureLoader.Option : MTKTextureLoader.Origin] = [MTKTextureLoader.Option.origin : _origin]
            
            do{
                result = try textureLoader.newTexture(URL: url, options: options)
                result.label = _textureName
            }catch let error as NSError {
                print("ERROR::CREATING::TEXTURE::__\(_textureName!)__::\(error)")
            }
        }else {
            print("ERROR::CREATING::TEXTURE::__\(_textureName!) does not exist")
        }
        
        return result
    }
}
