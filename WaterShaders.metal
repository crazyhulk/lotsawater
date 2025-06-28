#include <metal_stdlib>
using namespace metal;

// 顶点数据结构
struct Vertex {
    float3 position [[attribute(0)]]; // x, y, height
    float3 normal [[attribute(1)]];   // 法线
    float2 texCoord [[attribute(2)]]; // 纹理坐标
};

// 顶点着色器输出
struct VertexOut {
    float4 position [[position]];
    float2 texCoord;
    float3 worldPos;
    float3 normal;
    float height;
};

// 常量缓冲区
struct Constants {
    float4x4 modelViewProjectionMatrix;
    float4x4 normalMatrix;
    float time;
    float waterDepth;
    float2 waterSize;
    float2 textureSize;
    float imageFade;
};

// 顶点着色器
vertex VertexOut waterVertexShader(Vertex in [[stage_in]],
                                 constant Constants &constants [[buffer(1)]]) {
    VertexOut out;
    
    // 应用高度到顶点位置
    float3 worldPosition = in.position;
    worldPosition.z *= constants.waterDepth;
    
    // 变换到裁剪空间
    out.position = constants.modelViewProjectionMatrix * float4(worldPosition, 1.0);
    out.worldPos = worldPosition;
    out.texCoord = in.texCoord;
    out.normal = normalize((constants.normalMatrix * float4(in.normal, 0.0)).xyz);
    out.height = in.position.z;
    
    return out;
}

// 片段着色器
fragment float4 waterFragmentShader(VertexOut in [[stage_in]],
                                  texture2d<float> backgroundTexture [[texture(0)]],
                                  texture2d<float> reflectionTexture [[texture(1)]],
                                  constant Constants &constants [[buffer(1)]]) {
    constexpr sampler textureSampler(mag_filter::linear, min_filter::linear, address::clamp_to_edge);
    
    // 基础纹理坐标
    float2 texCoord = in.texCoord;
    
    // 计算水波纹扰动
    float3 normal = normalize(in.normal);
    float2 distortion = normal.xy * 0.1 * constants.waterDepth;
    
    // 应用扰动到纹理坐标
    float2 backgroundCoord = (texCoord + distortion) * constants.textureSize;
    
    // 采样背景纹理
    float4 backgroundColor = backgroundTexture.sample(textureSampler, backgroundCoord);
    
    // 计算反射坐标（球面映射）
    float3 viewDir = normalize(in.worldPos);
    float3 reflectDir = reflect(viewDir, normal);
    float2 reflectionCoord = float2(reflectDir.x * 0.5 + 0.5, reflectDir.y * 0.5 + 0.5);
    
    // 采样反射纹理
    float4 reflectionColor = reflectionTexture.sample(textureSampler, reflectionCoord);
    
    // 基于法线计算反射强度
    float reflectionStrength = saturate(dot(normal, float3(0.0, 0.0, 1.0)));
    reflectionStrength = pow(reflectionStrength, 2.0);
    
    // 混合背景和反射
    float4 finalColor = mix(backgroundColor, backgroundColor + reflectionColor * 0.5, reflectionStrength);
    
    // 应用透明度
    finalColor.a = constants.imageFade;
    
    return finalColor;
} 