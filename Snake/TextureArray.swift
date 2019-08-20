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
