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
            float4 gridColor,
            float4 backgroundColor) {
    
    float4 color = backgroundColor;
    float cellsWide = cellCounts.x;
    float cellsHigh = cellCounts.y;
    
    float x = fract(texCoord.x * cellsWide);
    float y = fract(texCoord.y * cellsHigh);
    if (x < lineWidth ||
        y < lineWidth ||
        x > 1 - lineWidth ||
        y > 1 - lineWidth)
        color = gridColor;
    
    return color;
}

fragment half4 grid_fragment_shader(RasterizerData rd [[ stage_in ]],
                                    constant GridConstants &gridConstants [[ buffer(1) ]]) {

    float2 texCoord = rd.textureCoordinate;
    
    float2 cellCounts = float2(gridConstants.cellsWide,gridConstants.cellsHigh);
    float lineWidth = 0.03;
    float4 gridColor = float4(1,0,1,1);
    float4 backgroundColor = float4(0,0,0,1);
    float4 color = grid(cellCounts,
                        lineWidth,
                        texCoord,
                        gridColor,
                        backgroundColor) * 0.3;
    
    
    return half4(color.r, color.g, color.b, color.a);
}

fragment half4 grid_background_fragment_shader(RasterizerData rd [[ stage_in ]],
                                    constant float &totalGameTime [[ buffer(0) ]],
                                    constant bool &isOver [[ buffer(1) ]]) {
    float4 color;
    if(isOver) {
        color = float4(1,0,0,1) * max(1 + cos(totalGameTime * 2), 0.1);
    }else{
        color = abs(float4(rd.textureCoordinate.x,rd.textureCoordinate.y,abs(sin(totalGameTime)), 1.0));
    }
    
    return half4(color.r, color.g, color.b, color.a);
}

fragment half4 snake_fragment_shader(RasterizerData rd [[ stage_in ]]) {
    float4 color = float4(0.7,0.3,0.7,1);
    
    return half4(color.r, color.g, color.b, color.a);
}

fragment half4 apple_fragment_shader(RasterizerData rd [[ stage_in ]],
                                     texture2d<float> texture [[ texture(0) ]],
                                     sampler sampler2d [[ sampler(0) ]]) {
    float4 color = texture.sample(sampler2d, rd.textureCoordinate);
    
    return half4(color.r, color.g, color.b, color.a);
}




