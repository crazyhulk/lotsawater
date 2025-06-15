#include <metal_stdlib>
using namespace metal;

// 常量缓冲区
struct NormalComputeParams {
    uint width;
    uint height;
    float scale;
};

// 计算着色器
kernel void computeNormals(
    device float* heights [[buffer(0)]],
    device float3* normals [[buffer(1)]],
    constant NormalComputeParams& params [[buffer(2)]],
    uint2 position [[thread_position_in_grid]])
{
    // 检查边界
    if (position.x >= params.width || position.y >= params.height) {
        return;
    }
    
    uint index = position.y * params.width + position.x;
    
    // 获取相邻点的高度
    float h_left = (position.x > 0) ? heights[index - 1] : heights[index];
    float h_right = (position.x < params.width - 1) ? heights[index + 1] : heights[index];
    float h_top = (position.y > 0) ? heights[index - params.width] : heights[index];
    float h_bottom = (position.y < params.height - 1) ? heights[index + params.width] : heights[index];
    
    // 计算法线
    float3 dx = float3(2.0f, 0.0f, (h_right - h_left) * params.scale);
    float3 dy = float3(0.0f, 2.0f, (h_bottom - h_top) * params.scale);
    
    // 计算叉积并归一化
    float3 normal = normalize(cross(dx, dy));
    
    // 存储法线
    normals[index] = normal;
} 