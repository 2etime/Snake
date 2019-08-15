#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float3 position [[ attribute(0) ]];
    float2 textureCoordinate [[ attribute(1) ]];
};

struct RasterizerData {
    float4 position [[ position ]];
    float2 textureCoordinate;
};

struct SceneConstants {
    float4x4 projectionMatrix;};

struct ModelConstants {
    float4x4 modelMatrix;
};

struct GridConstants {
    float totalGameTime;
    float cellsWide;
    float cellsHigh;
};

vertex RasterizerData basic_vertex_shader(Vertex vIn [[ stage_in ]],
                                         constant SceneConstants &sceneConstants [[ buffer(1) ]],
                                         constant ModelConstants &modelConstants [[ buffer(2) ]]) {
    RasterizerData rd;
    
    rd.position = sceneConstants.projectionMatrix * modelConstants.modelMatrix * float4(vIn.position, 1.0);
    rd.textureCoordinate = vIn.textureCoordinate;
    
    return rd;
}

float4 grid(float2 cellCounts,
            float lineWidth,
            float2 texCoord,
            float4 borderColor,
            float4 gridColor,
            float4 backgroundColor) {
    float4 color = backgroundColor;
    float cellsWide = cellCounts.x;
    float cellsHigh = cellCounts.y;
    
    float x, y;
    x = fract(texCoord.x * cellsWide);
    y = fract(texCoord.y * cellsHigh);
    
    if((x < lineWidth && texCoord.x < 1.0 / cellsWide) ||
       (x > 1.0 - lineWidth && texCoord.x > 1.0 - 1.0 / cellsWide) ||
       x >= 1.0 - lineWidth / 2.0 ||
       x <= lineWidth / 2.0) {
        color = gridColor;
    }
    
    if((y < lineWidth && texCoord.y < 1.0 / cellsHigh) ||
       (y > 1.0 - lineWidth && texCoord.y > 1 - 1.0 / cellsHigh) ||
       y >= 1.0 - lineWidth / 2.0 ||
       y <= lineWidth / 2.0) {
        color = gridColor;
    }
    
    // Border X
    if(texCoord.x < 1.0 / 40.0 || texCoord.x > 1.0 - 1.0 / 40.0) {
        color = borderColor;
    }
    
    // Border Y
    if(texCoord.y < 1.0 / 40.0 || texCoord.y > 1.0 - 1.0 / 40.0) {
        color = borderColor;
    }
    
    return color;
}

fragment half4 grid_fragment_shader(RasterizerData rd [[ stage_in ]],
                                    constant GridConstants &gridConstants [[ buffer(1) ]]) {

    float2 texCoord = rd.textureCoordinate;
    
    float4 bc = abs(float4(texCoord.x,texCoord.y,abs(sin(gridConstants.totalGameTime)), 1.0));
    float2 cellCounts = float2(gridConstants.cellsWide,gridConstants.cellsHigh);
    float lineWidth = 0.06;
    float4 borderColor = bc;
    float4 gridColor = float4(1,0,1,1);
    float4 backgroundColor = float4(0,0,0,1);
    float4 color = grid(cellCounts,
                        lineWidth,
                        texCoord,
                        borderColor,
                        gridColor,
                        backgroundColor);
    
    
    return half4(color.r, color.g, color.b, color.a);
}

fragment half4 snake_fragment_shader(RasterizerData rd [[ stage_in ]]) {
    float4 color = float4(1,0,0,1);
    
    return half4(color.r, color.g, color.b, color.a);
}

fragment half4 apple_fragment_shader(RasterizerData rd [[ stage_in ]],
                                     texture2d<float> texture [[ texture(0) ]],
                                     sampler sampler2d [[ sampler(0) ]]) {
    float4 color = texture.sample(sampler2d, rd.textureCoordinate);
    
    return half4(color.r, color.g, color.b, color.a);
}




