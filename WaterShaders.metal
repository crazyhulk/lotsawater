#include <metal_stdlib>
using namespace metal;

// 顶点数据结构
struct Vertex {
    float2 position [[attribute(0)]];
    float2 texCoord [[attribute(1)]];
};

// 顶点着色器输出
struct VertexOut {
    float4 position [[position]];
    float2 texCoord;
};

// 常量缓冲区
struct Constants {
    float time;
    float waterDepth;
    float2 waterSize;
};

// 顶点着色器
vertex VertexOut waterVertexShader(Vertex in [[stage_in]],
                                 constant Constants &constants [[buffer(1)]]) {
    VertexOut out;
    out.position = float4(in.position, 0.0, 1.0);
    out.texCoord = in.texCoord;
    return out;
}

// 片段着色器
fragment float4 waterFragmentShader(VertexOut in [[stage_in]],
                                  texture2d<float> reflectionTexture [[texture(0)]],
                                  constant Constants &constants [[buffer(1)]]) {
    constexpr sampler textureSampler(mag_filter::linear, min_filter::linear);
    
    // 计算水波纹效果
    float2 texCoord = in.texCoord;
    float time = constants.time;
    
    // 这里后续会添加水波纹的扰动计算
    float2 distortion = float2(0.0);
    
    // 应用扰动到纹理坐标
    texCoord += distortion;
    
    // 采样反射纹理
    float4 color = reflectionTexture.sample(textureSampler, texCoord);
    
    return color;
} 