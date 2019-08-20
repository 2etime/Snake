import MetalKit

enum TextureTypes{
    case None
    case SnakeHead
    case SnakeHeadDead
    case SnakeBody
    case SnakeBodyHit
    case SnakeTail
    case SnakeTurn
    case SnakeTurnHit
    
    case Apple
    case Apple0
    case Apple1
    case Apple2
    case Apple3
    case Apple4
}

class Textures {
    private static var _library: [TextureTypes: Texture] = [:]
    
    public static func Initialize() {
        _library.updateValue(Texture("SnakeHead"), forKey: .SnakeHead)
        _library.updateValue(Texture("SnakeHeadDead"), forKey: .SnakeHeadDead)
        _library.updateValue(Texture("SnakeBody"), forKey: .SnakeBody)
        _library.updateValue(Texture("SnakeBodyHit"), forKey: .SnakeBodyHit)
        _library.updateValue(Texture("SnakeTail"), forKey: .SnakeTail)
        _library.updateValue(Texture("SnakeTurn"), forKey: .SnakeTurn)
        _library.updateValue(Texture("SnakeTurnHit"), forKey: .SnakeTurnHit)
        
        _library.updateValue(Texture("apple"), forKey: .Apple)
        _library.updateValue(Texture("apple0"), forKey: .Apple0)
        _library.updateValue(Texture("apple1"), forKey: .Apple1)
        _library.updateValue(Texture("apple2"), forKey: .Apple2)
        _library.updateValue(Texture("apple3"), forKey: .Apple3)
        _library.updateValue(Texture("apple4"), forKey: .Apple4)
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

import MetalKit

class TextureArray: NSObject {
    var texture: MTLTexture!
    var width: Int = 0
    var height: Int = 0
    var arrayLength: Int = 0
    
    private var _textureCollection: [Int32:MTLTexture] = [:]
    
    init(arrayLength: Int = 1) {
        self.arrayLength = arrayLength
    }
    
    private func generateTexture() {
        let textureDescriptor = MTLTextureDescriptor()
        textureDescriptor.textureType = .type2DArray
        textureDescriptor.pixelFormat = GameSettings.MainPixelFormat
        textureDescriptor.width = self.width
        textureDescriptor.height = self.height
        textureDescriptor.arrayLength = self.arrayLength
        self.texture = Engine.Device.makeTexture(descriptor: textureDescriptor)
    }
    
    func setSlice(slice: Int32, tex: MTLTexture) {
        if(width == 0 || height == 0){
            width = tex.width
            height = tex.height
            generateTexture()
        }else{
            assert(tex.width == width, "The collection of textures needs to have the same size dimension")
        }
        
        //Add the texture to the collection for later use
        _textureCollection.updateValue(tex, forKey: slice)
        
        //Replace the slice region with the new texture
        let rowBytes = width * 4
        let length = rowBytes * height
        let bgraBytes = [UInt8](repeating: 0, count: length)
        tex.getBytes(UnsafeMutableRawPointer(mutating: bgraBytes),
                     bytesPerRow: rowBytes,
                     from: MTLRegionMake2D(0, 0, width, height),
                     mipmapLevel: 0)
        
        texture.replace(region: MTLRegionMake2D(0, 0, width, height),
                        mipmapLevel: 0,
                        slice: Int(slice),
                        withBytes: bgraBytes,
                        bytesPerRow: rowBytes,
                        bytesPerImage: bgraBytes.count)
    }
    
}
