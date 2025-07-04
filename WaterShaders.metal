#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float2 position [[attribute(0)]];
    float2 texCoord [[attribute(1)]];
    float4 color [[attribute(2)]];
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
    
    // Ultra-simple vertex test - fixed positions to ensure something renders
    out.position = float4(in.position.x, in.position.y, 0.0, 1.0);
    
    out.texCoord0 = in.texCoord;
    out.texCoord1 = in.texCoord;
    out.color = in.color;
    out.normal = in.normal;
    
    return out;
}

fragment float4 waterFragmentShader(VertexOut in [[stage_in]],
                                    texture2d<float> backgroundTexture [[texture(0)]],
                                    texture2d<float> reflectionTexture [[texture(1)]],
                                    sampler textureSampler [[sampler(0)]])
{
    // Fix macOS coordinate system - flip Y coordinate for desktop capture
    float2 texCoord = in.texCoord0;
    texCoord.y = 1.0 - texCoord.y;  // Flip Y to match macOS desktop orientation
    
    // Don't clamp texture coordinates - let the sampler handle edge cases with ClampToEdge
    // This allows water ripples to create proper distortion effects at edges
    
    // Sample the background texture - let sampler handle out-of-bounds coordinates
    float4 backgroundColor = backgroundTexture.sample(textureSampler, texCoord);

    // Apply vertex color modulation for water shading effect
    float4 modulatedColor = backgroundColor * in.color;
    
    // Sample reflection texture using sphere mapping coordinates from normal
    float3 normalizedNormal = normalize(in.normal);
    float2 sphereCoord;
    sphereCoord.x = normalizedNormal.x * 0.5 + 0.5;
    sphereCoord.y = normalizedNormal.y * 0.5 + 0.5;
    float4 reflectionColor = reflectionTexture.sample(textureSampler, sphereCoord);
    
    // Combine background with reflection for complete water effect
    float4 finalColor = modulatedColor + reflectionColor * 0.1;
    
    return finalColor;
}
