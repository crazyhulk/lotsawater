#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float2 position [[attribute(0)]];
    float2 texCoord [[attribute(1)]];
    uchar4 color [[attribute(2)]];
    float3 normal [[attribute(3)]];
};

struct VertexOut {
    float4 position [[position]];
    float2 texCoord0;
    float2 texCoord1;
    float4 color;
    float3 normal;
};

struct Uniforms {
    float4x4 projectionMatrix;
    float4x4 modelViewMatrix;
    float4x4 textureMatrix;
    float2 waterSize;
    float fade;
};

vertex VertexOut waterVertexShader(VertexIn in [[stage_in]],
                                   constant Uniforms& uniforms [[buffer(1)]])
{
    VertexOut out;
    
    float4 worldPosition = float4(in.position.x, in.position.y, 0.0, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * worldPosition;
    
    out.texCoord0 = in.texCoord;
    
    float3 normal = normalize(in.normal);
    float3 incident = float3(0.0, 0.0, -1.0);
    float3 reflected = reflect(incident, normal);
    
    out.texCoord1 = float2(
        reflected.x * 0.5 + 0.5,
        reflected.y * 0.5 + 0.5
    );
    
    out.color = float4(in.color) / 255.0;
    out.normal = normal;
    
    return out;
}

fragment float4 waterFragmentShader(VertexOut in [[stage_in]],
                                    texture2d<float> backgroundTexture [[texture(0)]],
                                    texture2d<float> reflectionTexture [[texture(1)]],
                                    sampler textureSampler [[sampler(0)]])
{
    float4 backgroundSample = backgroundTexture.sample(textureSampler, in.texCoord0);
    float4 reflectionSample = reflectionTexture.sample(textureSampler, in.texCoord1);
    
    float4 color = backgroundSample * in.color + reflectionSample;
    
    return color;
}