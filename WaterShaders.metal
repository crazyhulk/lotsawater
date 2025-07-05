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
    
    // Simple edge clamping to match OpenGL GL_TEXTURE_RECTANGLE behavior
    // Clamp coordinates to valid range [0,1] to avoid sampling black areas
    texCoord = clamp(texCoord, float2(0.0), float2(1.0));
    
    float4 backgroundColor = backgroundTexture.sample(textureSampler, texCoord);

    // Apply vertex color modulation for water shading effect
    float4 modulatedColor = backgroundColor * in.color;
    
    // Sample reflection texture using proper OpenGL-style sphere mapping
    float3 normalizedNormal = normalize(in.normal);
    // OpenGL GL_SPHERE_MAP calculation: includes Z component and view direction
    float m = 2.0 * sqrt(normalizedNormal.x * normalizedNormal.x + 
                        normalizedNormal.y * normalizedNormal.y + 
                        (normalizedNormal.z + 1.0) * (normalizedNormal.z + 1.0));
    float2 sphereCoord;
    sphereCoord.x = normalizedNormal.x / m + 0.5;
    sphereCoord.y = normalizedNormal.y / m + 0.5;
    float4 reflectionColor = reflectionTexture.sample(textureSampler, sphereCoord);
    
    // Match OpenGL dual texture blending: GL_MODULATE + GL_ADD
    // Use grayscale from reflection as additive lighting
    float reflectionBrightness = (reflectionColor.r + reflectionColor.g + reflectionColor.b) / 3.0;
    float4 finalColor = modulatedColor + float4(reflectionBrightness, reflectionBrightness, reflectionBrightness, 0.0) * 0.3;
    
    return finalColor;
}
