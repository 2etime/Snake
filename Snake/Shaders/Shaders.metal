#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float3 position [[ attribute(0) ]];
    float2 textureCoordinate [[ attribute(1) ]];
};

struct RasterizerData {
    float4 position [[ position ]];
    float2 textureCoordinate;
    float3 worldPosition;
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

struct LightData {
    float3 position;
    float3 color;
};

vertex RasterizerData basic_vertex_shader(Vertex vIn [[ stage_in ]],
                                         constant SceneConstants &sceneConstants [[ buffer(1) ]],
                                         constant ModelConstants &modelConstants [[ buffer(2) ]]) {
    RasterizerData rd;
    
    float4 worldPosition = modelConstants.modelMatrix * float4(vIn.position, 1.0);
    rd.position = sceneConstants.projectionMatrix * worldPosition;
    rd.textureCoordinate = vIn.textureCoordinate;
    rd.worldPosition = worldPosition.xyz;
    
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
                                    constant GridConstants &gridConstants [[ buffer(1) ]],
                                    constant int &lightCount [[ buffer(2) ]],
                                    constant LightData *lightDatas [[ buffer(3) ]]) {

    float2 texCoord = rd.textureCoordinate;
    
    float2 cellCounts = float2(gridConstants.cellsWide,gridConstants.cellsHigh);
    float lineWidth = 0.04;
    float4 gridColor = float4(1,0,1,1);
    float4 backgroundColor = float4(0.02,0.02,0.02,1);
    float4 color = grid(cellCounts,
                        lineWidth,
                        texCoord,
                        gridColor,
                        backgroundColor) * 0.3;
    
    float3 totalAttenuation = 0.0;
    for(int i = 0; i < lightCount; i++) {
        LightData lightData = lightDatas[i];
        
        float dist = distance(lightData.position, rd.worldPosition);
        float linearLightFalloff = 1.00;
        
        float3 attenuation = 1 / (dist * linearLightFalloff);
        totalAttenuation += max(attenuation, 0.054);
    }
    color *= float4(totalAttenuation, 1.0);
    
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

fragment half4 basic_fragment_shader(RasterizerData rd [[ stage_in ]],
                                     constant float4 &color [[ buffer(0) ]]) {
    
    return half4(color.r, color.g, color.b, color.a);
}

fragment half4 textured_fragment_shader(RasterizerData rd [[ stage_in ]],
                                        texture2d<float> texture [[ texture(0) ]],
                                        sampler sampler2d [[ sampler(0) ]]) {
    float4 color = texture.sample(sampler2d, rd.textureCoordinate);
    if(color.a <= 0.01) {
        discard_fragment();
    }
    return half4(color.r, color.g, color.b, color.a);
}

vertex RasterizerData instanced_vertex_shader(const Vertex vIn [[ stage_in ]],
                                              constant SceneConstants &sceneConstants [[ buffer(1) ]],
                                              constant ModelConstants *modelConstants [[ buffer(2) ]],
                                              uint instanceId [[ instance_id ]]){
    RasterizerData rd;
    
    ModelConstants modelConstant = modelConstants[instanceId];
    
    float4 worldPosition = modelConstant.modelMatrix * float4(vIn.position, 1.0);
    rd.position = sceneConstants.projectionMatrix * worldPosition;
    rd.textureCoordinate = vIn.textureCoordinate;
    rd.worldPosition = worldPosition.xyz;
    
    return rd;
}

fragment half4 apple_particles_fragment_shader(RasterizerData rd [[ stage_in ]],
                                     constant int &elapsedTime [[ buffer(0) ]]) {
    float4 color = float4(1.0,0.0,0.0,1) * (15 / (float)elapsedTime);
    
    return half4(color.r, color.g, color.b, color.a);
}




